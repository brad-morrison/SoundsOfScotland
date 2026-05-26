import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedTab = AppTab.home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppTab.home)

            StarredView()
                .tabItem {
                    Label("Starred", systemImage: "star.fill")
                }
                .tag(AppTab.starred)

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(AppTab.map)
        }
        .safeAreaInset(edge: .bottom) {
            if !appState.isNowPlayingPresented {
                MiniPlayerBar()
                    .environmentObject(appState)
                    .padding(.bottom, 56)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: appState.audioPlayer.currentSoundscape)
        .fullScreenCover(isPresented: $appState.isNowPlayingPresented) {
            NowPlayingViewNew()
                .environmentObject(appState)
        }
    }
}

private enum AppTab {
    case home
    case starred
    case map
}

#Preview {
    RootView()
        .environmentObject(AppState())
}
