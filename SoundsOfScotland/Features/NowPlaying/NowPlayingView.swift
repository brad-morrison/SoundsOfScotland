import SwiftUI

struct NowPlayingView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack {
            (isDarkMode ? Color(red: 0.04, green: 0.06, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.94))
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
                    colors: isDarkMode
                        ? [
                            .black.opacity(0.18),
                            .black.opacity(0.32),
                            .black.opacity(0.84)
                        ]
                        : [
                            .white.opacity(0.1),
                            .white.opacity(0.28),
                            .white.opacity(0.78)
                        ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(width: proxy.size.width, height: proxy.size.height)
                .ignoresSafeArea()

                nowPlayingContent(for: soundscape)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .zIndex(10)
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .ignoresSafeArea()
    }

    private func nowPlayingContent(for soundscape: Soundscape) -> some View {
        GeometryReader { proxy in
            let topPadding = proxy.safeAreaInsets.top + 96
            let bottomPadding = max(proxy.safeAreaInsets.bottom, 16) + 52

            VStack(spacing: 0) {
                VStack(spacing: 14) {
                    Text(soundscape.subtitle.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .tracking(2)
                        .foregroundStyle(isDarkMode ? .white.opacity(0.7) : .black.opacity(0.7))

                    Text(soundscape.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(isDarkMode ? .white : .black)

                    Text(soundscape.description)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(isDarkMode ? .white.opacity(0.75) : .black.opacity(0.75))
                        .padding(.horizontal, 32)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 32)
                .padding(.top, topPadding)

                Spacer(minLength: 24)

                HStack(alignment: .center, spacing: 28) {
                    Button {
                        appState.closeNowPlaying()
                    } label: {
                        controlIcon("chevron.down")
                    }

                    playButton(for: soundscape)

                    Button {
                        appState.toggleFavourite(soundscape)
                    } label: {
                        controlIcon(appState.isFavourite(soundscape) ? "star.fill" : "star")
                    }
                }
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .padding(.bottom, bottomPadding)
            }
        }
    }

    private func playButton(for soundscape: Soundscape) -> some View {
        let isCurrentSoundscape = appState.audioPlayer.currentSoundscape?.id == soundscape.id
        let isPlaying = isCurrentSoundscape && appState.audioPlayer.isPlaying

        return Button {
            appState.audioPlayer.togglePlayback(for: soundscape)
        } label: {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .font(.title)
                .foregroundStyle(isDarkMode ? .black : .black)
                .frame(width: 78, height: 78)
                .background(isDarkMode ? Color.white : Color.white)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.28), radius: 22, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }

    private func controlIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.headline)
            .foregroundStyle(isDarkMode ? .white : .black)
            .frame(width: 52, height: 52)
            .background(isDarkMode ? Color.black.opacity(0.36) : Color.white.opacity(0.55))
            .clipShape(Circle())
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "waveform")
                .font(.largeTitle)

            Text("Nothing playing yet")
                .font(.headline)

            Text("Choose a soundscape from Home to begin.")
                .font(.body)
                .foregroundStyle(isDarkMode ? .white.opacity(0.7) : .black.opacity(0.7))
        }
        .foregroundStyle(isDarkMode ? .white : .black)
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    let state = AppState()
    state.selectedSoundscape = MockSoundscapes.all[0]

    return NowPlayingView()
        .environmentObject(state)
}
