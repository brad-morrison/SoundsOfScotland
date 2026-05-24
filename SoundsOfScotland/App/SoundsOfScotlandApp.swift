import SwiftUI

@main
struct SoundsOfScotlandApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
