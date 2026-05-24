import SwiftUI

struct MiniPlayerBar: View {
    @EnvironmentObject private var appState: AppState
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        if let soundscape = appState.audioPlayer.currentSoundscape {
            Button {
                appState.selectedSoundscape = soundscape
                appState.isNowPlayingPresented = true
            } label: {
                HStack(spacing: 12) {
                    Image(soundscape.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 52)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                    VStack(alignment: .leading, spacing: 3) {
                        Text("Now Playing")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(isDarkMode ? .white.opacity(0.58) : .black.opacity(0.58))

                        Text(soundscape.title)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(isDarkMode ? .white : .black)
                            .lineLimit(1)
                    }

                    Spacer()

                    Button {
                        appState.audioPlayer.togglePlayback(for: soundscape)
                    } label: {
                        Image(systemName: appState.audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.headline)
                            .foregroundStyle(isDarkMode ? .black : .white)
                            .frame(width: 42, height: 42)
                            .background(isDarkMode ? Color.white : Color.black)
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(10)
                .background(isDarkMode ? AnyShapeStyle(.ultraThinMaterial) : AnyShapeStyle(Color.white.opacity(0.85)))
                .opacity(isDarkMode ? 0.92 : 1.0)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                }
                .shadow(color: .black.opacity(0.25), radius: 18, x: 0, y: 8)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
            .buttonStyle(.plain)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

#Preview {
    let state = AppState()
    state.selectedSoundscape = MockSoundscapes.all[0]
    state.audioPlayer.play(MockSoundscapes.all[0])

    return ZStack {
        Color(red: 0.04, green: 0.06, blue: 0.12)
            .ignoresSafeArea()

        VStack {
            Spacer()
            MiniPlayerBar()
                .environmentObject(state)
        }
    }
}

