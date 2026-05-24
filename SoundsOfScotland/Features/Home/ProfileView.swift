import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @StateObject private var authVM = AuthViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.12))
                        .frame(width: 88, height: 88)
                        .overlay {
                            Circle().stroke(isDarkMode ? Color.white.opacity(0.15) : Color.black.opacity(0.15), lineWidth: 1)
                        }

                    if let initials = (authVM.user?.displayName?.split(separator: " ")
                        .compactMap { $0.first }.map(String.init).prefix(2).joined()), !initials.isEmpty {
                        Text(initials)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(isDarkMode ? .white : .black)
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundStyle(isDarkMode ? .white : .black)
                    }
                }
                .padding(.top, 24)

                if let user = authVM.user {
                    VStack(spacing: 16) {
                        VStack(spacing: 8) {
                            Text("Hi, \(greetingName(for: user))!")
                                .font(.title2.bold())
                                .foregroundStyle(isDarkMode ? .white : .black)

                            Text("Your Sounds of Scotland profile is ready for quieter moments, favourite places, and saved listening.")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .lineSpacing(3)
                                .foregroundStyle(isDarkMode ? .white.opacity(0.68) : .black.opacity(0.68))
                        }

                        VStack(spacing: 0) {
                            ProfileInfoRow(
                                iconName: "person.crop.circle",
                                title: "Account",
                                value: displayName(for: user),
                                isDarkMode: isDarkMode
                            )

                            Divider()
                                .overlay(isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.12))
                                .padding(.leading, 52)

                            ProfileInfoRow(
                                iconName: "envelope",
                                title: "Email",
                                value: user.email?.isEmpty == false ? (user.email ?? "") : "Hidden by Apple",
                                isDarkMode: isDarkMode
                            )

                            Divider()
                                .overlay(isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.12))
                                .padding(.leading, 52)

                            ProfileInfoRow(
                                iconName: "heart",
                                title: "Favourites",
                                value: "\(appState.favouriteSoundscapeIDs.count) saved",
                                isDarkMode: isDarkMode
                            )
                        }
                        .background(isDarkMode ? Color.white.opacity(0.08) : Color.white.opacity(0.65))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.08), lineWidth: 1)
                        }

                        Text("User ID: \(user.id)")
                            .font(.caption2)
                            .foregroundStyle(isDarkMode ? .white : .black)
                            .opacity(0.45)
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                } else {
                    Text("Not signed in")
                        .font(.headline)
                        .foregroundStyle(isDarkMode ? .white : .black)
                }

                Spacer()

                Link(destination: URL(string: "https://appleid.apple.com/")!) {
                    Text("Manage Apple ID")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(isDarkMode ? Color.white.opacity(0.12) : Color.black.opacity(0.12))
                        .foregroundStyle(isDarkMode ? .white : .black)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.horizontal)

                Button(role: .destructive) {
                    authVM.signOut()
                    dismiss()
                } label: {
                    Text("Sign Out")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.red.opacity(0.15))
                        .foregroundStyle(.red)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .padding(.horizontal)
            .background(isDarkMode ? Color(red: 0.04, green: 0.06, blue: 0.12) : Color(red: 0.98, green: 0.97, blue: 0.94))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func displayName(for user: AuthenticatedUser) -> String {
        guard let displayName = user.displayName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !displayName.isEmpty else {
            return "Signed in with Apple"
        }

        return displayName
    }

    private func greetingName(for user: AuthenticatedUser) -> String {
        guard let displayName = user.displayName?.trimmingCharacters(in: .whitespacesAndNewlines),
              !displayName.isEmpty else {
            return "there"
        }

        return displayName
            .split(separator: " ")
            .first
            .map(String.init) ?? "there"
    }
}

private struct ProfileInfoRow: View {
    let iconName: String
    let title: String
    let value: String
    let isDarkMode: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundStyle(isDarkMode ? .white.opacity(0.78) : .black.opacity(0.72))
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(isDarkMode ? .white.opacity(0.58) : .black.opacity(0.58))

                Text(value)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(isDarkMode ? .white : .black)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer(minLength: 0)
        }
        .frame(minHeight: 58)
        .padding(.horizontal, 14)
    }
}
#Preview {
    ProfileView()
        .environmentObject(AppState())
}
