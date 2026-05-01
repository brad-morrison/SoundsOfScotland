import Foundation
import Combine

@MainActor
final class AppState: ObservableObject {
    @Published var selectedSoundscape: Soundscape?
    @Published var isNowPlayingPresented = false
    @Published private(set) var favouriteSoundscapeIDs: Set<String> = [] {
        didSet {
            saveFavouriteSoundscapeIDs()
        }
    }

    let audioPlayer = AudioPlayerService()

    private var cancellables = Set<AnyCancellable>()
    private let favouritesKey = "favouriteSoundscapeIDs"

    init() {
        favouriteSoundscapeIDs = loadFavouriteSoundscapeIDs()

        audioPlayer.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    func select(_ soundscape: Soundscape) {
        selectedSoundscape = soundscape
        audioPlayer.play(soundscape)
        isNowPlayingPresented = true
    }

    func closeNowPlaying() {
        isNowPlayingPresented = false
    }

    func isFavourite(_ soundscape: Soundscape) -> Bool {
        favouriteSoundscapeIDs.contains(soundscape.id)
    }

    func toggleFavourite(_ soundscape: Soundscape) {
        if favouriteSoundscapeIDs.contains(soundscape.id) {
            favouriteSoundscapeIDs.remove(soundscape.id)
        } else {
            favouriteSoundscapeIDs.insert(soundscape.id)
        }
    }

    private func saveFavouriteSoundscapeIDs() {
        let ids = Array(favouriteSoundscapeIDs)
        UserDefaults.standard.set(ids, forKey: favouritesKey)
    }

    private func loadFavouriteSoundscapeIDs() -> Set<String> {
        let ids = UserDefaults.standard.stringArray(forKey: favouritesKey) ?? []
        return Set(ids)
    }
}
