import SwiftUI

struct NowPlayingView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            Color(red: 0.04, green: 0.06, blue: 0.12)
                .ignoresSafeArea()

            if let soundscape = appState.selectedSoundscape {
                content(for: soundscape)
            } else {
                emptyState
            }
        }
        .gesture(
            DragGesture(minimumDistance: 20)
                .onEnded { value in
                    if value.translation.height > 80 && abs(value.translation.width) < 100 {
                        appState.closeNowPlaying()
                    }
                }
        )
    }

    private func content(for soundscape: Soundscape) -> some View {
        GeometryReader { proxy in
            ZStack {
                Image(soundscape.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
                    .ignoresSafeArea()

                LinearGradient(
                    colors: [
                        .black.opacity(0.2),
                        .black.opacity(0.45),
                        .black.opacity(0.9)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: proxy.size.width, height: proxy.size.height)
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    nowPlayingContent(for: soundscape)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .padding(.top, 0)
                .zIndex(10)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }

    private func topBar(for soundscape: Soundscape) -> some View {
        HStack {
            Button {
                appState.closeNowPlaying()
            } label: {
                Image(systemName: "chevron.down")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(.black.opacity(0.45))
                    .clipShape(Circle())
            }

            Spacer()

            Button {
                appState.toggleFavourite(soundscape)
            } label: {
                Image(systemName: appState.isFavourite(soundscape) ? "star.fill" : "star")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(width: 48, height: 48)
                    .background(.black.opacity(0.45))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
    }

    private func nowPlayingContent(for soundscape: Soundscape) -> some View {
        VStack(spacing: 14) {
            Text(soundscape.subtitle.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .tracking(2)
                .foregroundStyle(.white.opacity(0.7))

            Text(soundscape.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Text(soundscape.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundStyle(.white.opacity(0.75))
                .padding(.horizontal, 32)
                .frame(maxWidth: .infinity)

            HStack(alignment: .center, spacing: 28) {
                // Return (close) button
                Button {
                    appState.closeNowPlaying()
                } label: {
                    Image(systemName: "chevron.down")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(.black.opacity(0.45))
                        .clipShape(Circle())
                }

                // Center play/pause button
                playButton(for: soundscape)

                // Star (favourite) button
                Button {
                    appState.toggleFavourite(soundscape)
                } label: {
                    Image(systemName: appState.isFavourite(soundscape) ? "star.fill" : "star")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 48, height: 48)
                        .background(.black.opacity(0.45))
                        .clipShape(Circle())
                }
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(.top, 22)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 28)
        .padding(.bottom, 20)
        .padding(.bottom, safeAreaBottomPadding())
    }

    private func playButton(for soundscape: Soundscape) -> some View {
        let isCurrentSoundscape = appState.audioPlayer.currentSoundscape?.id == soundscape.id
        let isPlaying = isCurrentSoundscape && appState.audioPlayer.isPlaying

        return Button {
            appState.audioPlayer.togglePlayback(for: soundscape)
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.title)
                .foregroundStyle(.black)
                .frame(width: 78, height: 78)
                .background(.white)
                .clipShape(Circle())
                .shadow(radius: 20)
        }
        .buttonStyle(.plain)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "waveform")
                .font(.largeTitle)

            Text("Nothing playing yet")
                .font(.headline)

            Text("Choose a soundscape from Home to begin.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding()
    }

    private func safeAreaBottomPadding() -> CGFloat {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            return max(window.safeAreaInsets.bottom, 0)
        }
        return 0
    }
}

#Preview {
    let state = AppState()
    state.selectedSoundscape = MockSoundscapes.all[0]

    return NowPlayingView()
        .environmentObject(state)
}
