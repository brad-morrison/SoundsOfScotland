import Foundation
import AVFoundation
import Combine
import MediaPlayer
import UIKit

@MainActor
final class AudioPlayerService: NSObject, ObservableObject {
    @Published private(set) var currentSoundscape: Soundscape?
    @Published private(set) var isPlaying = false

    private var player: AVAudioPlayer?

    override init() {
        super.init()
        configureAudioSession()
        observeAudioSessionNotifications()
        setupRemoteCommands()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func play(_ soundscape: Soundscape) {
        if currentSoundscape?.id == soundscape.id {
            resume()
            updateNowPlayingInfo(for: soundscape)
            return
        }

        load(soundscape)
        resume()
        updateNowPlayingInfo(for: soundscape)
    }

    func togglePlayback(for soundscape: Soundscape) {
        if currentSoundscape?.id != soundscape.id {
            play(soundscape)
            return
        }

        if isPlaying {
            pause()
        } else {
            resume()
        }
    }

    func pause() {
        player?.pause()
        isPlaying = false

        if let currentSoundscape {
            updateNowPlayingInfo(for: currentSoundscape)
        }
    }

    func stop() {
        player?.stop()
        player = nil
        currentSoundscape = nil
        isPlaying = false
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nil
    }

    private func resume() {
        guard let player else { return }

        do {
            try AVAudioSession.sharedInstance().setActive(true)
            player.play()
            isPlaying = true

            if let currentSoundscape {
                updateNowPlayingInfo(for: currentSoundscape)
            }
        } catch {
            print("Failed to resume audio: \(error.localizedDescription)")
        }
    }

    private func load(_ soundscape: Soundscape) {
        guard let url = Bundle.main.url(
            forResource: soundscape.audioFileName,
            withExtension: "wav"
        ) else {
            print("Could not find audio file: \(soundscape.audioFileName).wav")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.prepareToPlay()
            currentSoundscape = soundscape
        } catch {
            print("Failed to load audio: \(error.localizedDescription)")
        }
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: []
            )

            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure audio session: \(error.localizedDescription)")
        }
    }

    private func observeAudioSessionNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioSessionInterruption),
            name: AVAudioSession.interruptionNotification,
            object: AVAudioSession.sharedInstance()
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAudioRouteChange),
            name: AVAudioSession.routeChangeNotification,
            object: AVAudioSession.sharedInstance()
        )
    }

    @objc private func handleAudioSessionInterruption(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let typeValue = info[AVAudioSessionInterruptionTypeKey] as? UInt,
            let type = AVAudioSession.InterruptionType(rawValue: typeValue)
        else {
            return
        }

        switch type {
        case .began:
            pause()

        case .ended:
            guard
                let optionsValue = info[AVAudioSessionInterruptionOptionKey] as? UInt
            else {
                return
            }

            let options = AVAudioSession.InterruptionOptions(rawValue: optionsValue)

            if options.contains(.shouldResume) {
                resume()
            }

        @unknown default:
            break
        }
    }

    @objc private func handleAudioRouteChange(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let reasonValue = info[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue)
        else {
            return
        }

        switch reason {
        case .oldDeviceUnavailable:
            pause()

        default:
            break
        }
    }

    private func setupRemoteCommands() {
        let commandCenter = MPRemoteCommandCenter.shared()

        commandCenter.playCommand.addTarget { [weak self] _ in
            Task { @MainActor in
                self?.resume()
            }

            return .success
        }

        commandCenter.pauseCommand.addTarget { [weak self] _ in
            Task { @MainActor in
                self?.pause()
            }

            return .success
        }

        commandCenter.togglePlayPauseCommand.addTarget { [weak self] _ in
            Task { @MainActor in
                guard let currentSoundscape = self?.currentSoundscape else { return }
                self?.togglePlayback(for: currentSoundscape)
            }

            return .success
        }
    }

    private func updateNowPlayingInfo(for soundscape: Soundscape) {
        var info: [String: Any] = [
            MPMediaItemPropertyTitle: soundscape.title,
            MPMediaItemPropertyArtist: "Sounds of Scotland",
            MPNowPlayingInfoPropertyPlaybackRate: isPlaying ? 1.0 : 0.0
        ]

        if let image = UIImage(named: soundscape.imageName) {
            let artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in
                image
            }

            info[MPMediaItemPropertyArtwork] = artwork
        }

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
}
