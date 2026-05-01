import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                StarredView()
                    .tabItem {
                        Label("Starred", systemImage: "star.fill")
                    }

                MapView()
                    .tabItem {
                        Label("Map", systemImage: "map.fill")
                    }

                NowPlayingView()
                    .tabItem {
                        Label("Playing", systemImage: "play.circle.fill")
                    }
            }

            if !appState.isNowPlayingPresented {
                MiniPlayerBar()
                    .environmentObject(appState)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: appState.audioPlayer.currentSoundscape)
        .fullScreenCover(isPresented: $appState.isNowPlayingPresented) {
            NowPlayingView()
                .environmentObject(appState)
        }
    }
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
