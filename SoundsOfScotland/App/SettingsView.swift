import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: "moon.fill")
                    }
                }

                Section(header: Text("About")) {
                    Text("Sounds of Scotland v1.0")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
        .background(isDarkMode ? Color(red: 0.04, green: 0.06, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.94))
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
        .environmentObject(AppState())
}
