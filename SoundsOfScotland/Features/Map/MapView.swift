import SwiftUI

struct MapView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            Text("Map coming soon.")
                .foregroundStyle(.secondary)
                .padding()
                .navigationTitle("Map")
        }
        .background(isDarkMode ? Color(red: 0.04, green: 0.06, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.94))
        .ignoresSafeArea()
    }
}

#Preview {
    MapView()
}
