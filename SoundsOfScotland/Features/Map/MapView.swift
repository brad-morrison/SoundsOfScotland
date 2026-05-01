import SwiftUI

struct MapView: View {
    var body: some View {
        NavigationStack {
            Text("Map coming soon.")
                .foregroundStyle(.secondary)
                .padding()
                .navigationTitle("Map")
        }
    }
}

#Preview {
    MapView()
}
