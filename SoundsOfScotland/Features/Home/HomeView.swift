import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var isSettingsPresented = false

    private let soundscapes = MockSoundscapes.all

    private var featuredSoundscape: Soundscape? {
        soundscapes.first
    }

    private var newSoundscapes: [Soundscape] {
        Array(soundscapes.dropFirst())
    }

    private var recentSoundscapes: [Soundscape] {
        Array(soundscapes.prefix(5))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                background

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 28) {
                        header

                        Text(appState.isAuthPresented ? "Auth sheet: PRESENTED" : "Auth sheet: NOT presented")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)

                        featuredSection

                        recentSection

                        newSection

                        trySomethingNewSection

                        comingSoonSection
                    }
                    .padding(.top, 14)
                    .padding(.bottom, 120)
                }
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView()
                    .environmentObject(appState)
            }
            .sheet(isPresented: Binding(
                get: { appState.isAuthPresented },
                set: { appState.isAuthPresented = $0 }
            )) {
                AuthView()
                    .environmentObject(appState)
            }
            .sheet(isPresented: Binding(
                get: { appState.isProfilePresented },
                set: { appState.isProfilePresented = $0 }
            )) {
                ProfileView()
                    .environmentObject(appState)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var background: some View {
        Group {
            if isDarkMode {
                LinearGradient(
                    colors: [
                        Color(red: 0.025, green: 0.04, blue: 0.09),
                        Color(red: 0.045, green: 0.065, blue: 0.14),
                        Color(red: 0.025, green: 0.035, blue: 0.08)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            } else {
                LinearGradient(
                    colors: [
                        Color.white,
                        Color(red: 0.98, green: 0.97, blue: 0.94),
                        Color(red: 0.91, green: 0.93, blue: 0.95)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
        }
        .ignoresSafeArea()
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sounds of")
                        .font(.system(size: 22, weight: .semibold, design: .rounded))
                        .foregroundStyle(isDarkMode ? .white.opacity(0.82) : .black.opacity(0.82))

                    Text("Scotland")
                        .font(.system(size: 40, weight: .black, design: .rounded))
                        .foregroundStyle(isDarkMode ? .white : .black)
                        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 8)
                }

                Spacer()

                Button {
                    isSettingsPresented = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.title3)
                        .foregroundStyle(isDarkMode ? .white : .black)
                        .frame(width: 42, height: 42)
                        .background((isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.1)))
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke((isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.12)), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)

                Button {
                    print("HomeView: Profile button tapped")
                    if appState.isAuthenticated {
                        appState.isProfilePresented = true
                    } else {
                        appState.isAuthPresented = true
                    }
                } label: {
                    Image(systemName: appState.isAuthenticated ? "person.crop.circle.fill" : "person.crop.circle")
                        .font(.title3)
                        .foregroundStyle(isDarkMode ? .white : .black)
                        .frame(width: 42, height: 42)
                        .background((isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.1)))
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke((isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.12)), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
            }

            Text("Escape into immersive Scottish soundscapes, from quiet lochs to wild coastal storms.")
                .font(.subheadline)
                .foregroundStyle(isDarkMode ? .white.opacity(0.68) : .black.opacity(0.68))
                .lineSpacing(3)
        }
        .padding(.horizontal, 20)
    }

    private var featuredSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Featured", actionTitle: "See all")

            if let featuredSoundscape {
                HeroSoundscapeCard(soundscape: featuredSoundscape, isDarkMode: isDarkMode) {
                    appState.select(featuredSoundscape)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Recent", actionTitle: nil)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(recentSoundscapes) { soundscape in
                        RecentSoundscapeButton(soundscape: soundscape, isDarkMode: isDarkMode) {
                            appState.select(soundscape)
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private var newSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "New", actionTitle: "See all")

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 18) {
                    ForEach(newSoundscapes) { soundscape in
                        SoundscapeCard(soundscape: soundscape) {
                            appState.select(soundscape)
                        }
                        .frame(width: 240)
                    }
                }
                .padding(.bottom, 4)
            }
            .contentMargins(.horizontal, 20, for: .scrollContent)
        }
    }

    private var trySomethingNewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Try Something New", actionTitle: nil)

            Button {
                if let randomSoundscape = soundscapes.randomElement() {
                    appState.select(randomSoundscape)
                }
            } label: {
                HStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [.cyan.opacity(0.75), .purple.opacity(0.75)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )

                        Image(systemName: "shuffle")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    }
                    .frame(width: 52, height: 52)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Take me somewhere")
                            .font(.headline)
                            .foregroundStyle(isDarkMode ? .white : .black)

                        Text("Jump into a random Scottish atmosphere")
                            .font(.subheadline)
                            .foregroundStyle(isDarkMode ? .white.opacity(0.62) : .black.opacity(0.62))
                            .lineLimit(1)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundStyle(isDarkMode ? .white.opacity(0.55) : .black.opacity(0.55))
                }
                .padding(14)
                .background(isDarkMode ? Color.white.opacity(0.08) : Color.black.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.1), lineWidth: 1)
                }
                .padding(.horizontal, 20)
            }
            .buttonStyle(.plain)
        }
    }

    private var comingSoonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(title: "Coming Soon", actionTitle: nil)

            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "sparkles")
                        .font(.title3)
                        .foregroundStyle(isDarkMode ? .white : .black)

                    Spacer()

                    Text("Soon")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(isDarkMode ? .white.opacity(0.72) : .black.opacity(0.72))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.12))
                        .clipShape(Capsule())
                }

                Text("More locations are being prepared")
                    .font(.headline)
                    .foregroundStyle(isDarkMode ? .white : .black)

                Text("Future soundscapes could include Skye rain, harbour mornings, Highland winds and quiet bothy nights.")
                    .font(.subheadline)
                    .foregroundStyle(isDarkMode ? .white.opacity(0.62) : .black.opacity(0.62))
                    .lineSpacing(3)
            }
            .padding(16)
            .background(
                LinearGradient(
                    colors: isDarkMode ? [.white.opacity(0.11), .white.opacity(0.05)] : [.black.opacity(0.11), .black.opacity(0.05)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(isDarkMode ? Color.white.opacity(0.09) : Color.black.opacity(0.09), lineWidth: 1)
            }
            .padding(.horizontal, 20)
        }
    }

    private func sectionHeader(title: String, actionTitle: String?) -> some View {
        HStack {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(isDarkMode ? .white : .black)

            Spacer()

            if let actionTitle {
                Button(actionTitle) {
                    // Section action will come later.
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(isDarkMode ? .white.opacity(0.58) : .black.opacity(0.58))
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct HeroSoundscapeCard: View {
    let soundscape: Soundscape
    let isDarkMode: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                Image(soundscape.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 230)
                    .frame(maxWidth: .infinity)
                    .clipped()

                LinearGradient(
                    colors: isDarkMode ?
                        [.clear, .black.opacity(0.35), .black.opacity(0.82)] :
                        [.clear, .white.opacity(0.35), .white.opacity(0.82)],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 8) {
                        if soundscape.isPremium {
                            Label("Premium", systemImage: "lock.fill")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundStyle(isDarkMode ? .white : .black)
                                .padding(.horizontal, 9)
                                .padding(.vertical, 6)
                                .background(isDarkMode ? Color.black.opacity(0.35) : Color.white.opacity(0.35))
                                .clipShape(Capsule())
                        }

                        Label("Immersive", systemImage: "waveform")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(isDarkMode ? .white : .black)
                            .padding(.horizontal, 9)
                            .padding(.vertical, 6)
                            .background(isDarkMode ? Color.black.opacity(0.35) : Color.white.opacity(0.35))
                            .clipShape(Capsule())
                    }

                    Text(soundscape.title)
                        .font(.system(size: 28, weight: .black, design: .rounded))
                        .foregroundStyle(isDarkMode ? .white : .black)
                        .lineLimit(2)

                    Text(soundscape.description)
                        .font(.caption)
                        .foregroundStyle(isDarkMode ? .white.opacity(0.74) : .black.opacity(0.74))
                        .lineLimit(2)
                        .lineSpacing(3)
                }
                .padding(18)
            }
            .frame(height: 230)
            .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(isDarkMode ? Color.white.opacity(0.11) : Color.black.opacity(0.11), lineWidth: 1)
            }
            .shadow(color: isDarkMode ? Color.black.opacity(0.35) : Color.black.opacity(0.15), radius: isDarkMode ? 18 : 8, x: 0, y: 10)
        }
        .buttonStyle(.plain)
    }
}

private struct RecentSoundscapeButton: View {
    let soundscape: Soundscape
    let isDarkMode: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    Image(soundscape.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(isDarkMode ? Color.white.opacity(0.16) : Color.black.opacity(0.16), lineWidth: 1)
                        }
                        .shadow(color: isDarkMode ? Color.black.opacity(0.24) : Color.black.opacity(0.12), radius: 10, x: 0, y: 6)

                    if soundscape.isPremium {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(isDarkMode ? .white : .black)
                            .frame(width: 22, height: 22)
                            .background(isDarkMode ? Color.black.opacity(0.6) : Color.white.opacity(0.6))
                            .clipShape(Circle())
                            .offset(x: 2, y: -2)
                    }
                }
                .frame(width: 76, height: 76)

                Text(soundscape.title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(isDarkMode ? .white.opacity(0.82) : .black.opacity(0.82))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(width: 82, height: 28, alignment: .top)
            }
            .frame(width: 84)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .environmentObject(AppState())
}

