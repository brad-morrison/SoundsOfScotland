import SwiftUI

struct StarredView: View {
    @EnvironmentObject private var appState: AppState

    private var favouriteSoundscapes: [Soundscape] {
        MockSoundscapes.all.filter { soundscape in
            appState.favouriteSoundscapeIDs.contains(soundscape.id)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.04, green: 0.06, blue: 0.12)
                    .ignoresSafeArea()

                if favouriteSoundscapes.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(favouriteSoundscapes) { soundscape in
                                SoundscapeCard(soundscape: soundscape) {
                                    appState.select(soundscape)
                                }
                            }
                        }
                        .padding(20)
                    }
                }
            }
            .navigationTitle("Starred")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "star")
                .font(.largeTitle)

            Text("No favourites yet")
                .font(.headline)

            Text("Star a soundscape and it will appear here.")
                .font(.body)
                .foregroundStyle(.white.opacity(0.65))
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding()
    }
}

#Preview {
    StarredView()
        .environmentObject(AppState())
}
