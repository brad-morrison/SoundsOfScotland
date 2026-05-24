import Foundation
import Combine
import AuthenticationServices

@MainActor
final class AppState: ObservableObject {
    @Published var selectedSoundscape: Soundscape?
    @Published var isNowPlayingPresented = false
    @Published var isProfilePresented = false
    @Published private(set) var favouriteSoundscapeIDs: Set<String> = [] {
        didSet {
            saveFavouriteSoundscapeIDs()
        }
    }
    @Published var isAuthPresented = false
    @Published private(set) var currentUser: AuthenticatedUser? = AuthService.shared.currentUser

    var isAuthenticated: Bool { currentUser != nil }

    let audioPlayer = AudioPlayerService()

    private var cancellables = Set<AnyCancellable>()
    private let legacyFavouritesKey = "favouriteSoundscapeIDs"
    private var currentUserFavouritesKey: String? {
        guard let userID = currentUser?.id else { return nil }
        return "\(legacyFavouritesKey).\(userID)"
    }

    init() {
        favouriteSoundscapeIDs = loadFavouriteSoundscapeIDs()

        audioPlayer.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        NotificationCenter.default.addObserver(forName: .authStateChanged, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }

            currentUser = AuthService.shared.currentUser
            favouriteSoundscapeIDs = loadFavouriteSoundscapeIDs()
        }
    }

    func select(_ soundscape: Soundscape) {
        selectedSoundscape = soundscape
        audioPlayer.play(soundscape)
        isNowPlayingPresented = true
    }

    func closeNowPlaying() {
        isNowPlayingPresented = false
    }

    func isFavourite(_ soundscape: Soundscape) -> Bool {
        favouriteSoundscapeIDs.contains(soundscape.id)
    }

    func toggleFavourite(_ soundscape: Soundscape) {
        guard isAuthenticated else {
            favouriteSoundscapeIDs = []
            isAuthPresented = true
            return
        }

        if favouriteSoundscapeIDs.contains(soundscape.id) {
            favouriteSoundscapeIDs.remove(soundscape.id)
        } else {
            favouriteSoundscapeIDs.insert(soundscape.id)
        }
    }

    private func saveFavouriteSoundscapeIDs() {
        guard let favouritesKey = currentUserFavouritesKey else { return }

        let ids = Array(favouriteSoundscapeIDs)
        UserDefaults.standard.set(ids, forKey: favouritesKey)
    }

    private func loadFavouriteSoundscapeIDs() -> Set<String> {
        guard let favouritesKey = currentUserFavouritesKey else { return [] }

        if let ids = UserDefaults.standard.stringArray(forKey: favouritesKey) {
            return Set(ids)
        }

        if let legacyIDs = UserDefaults.standard.stringArray(forKey: legacyFavouritesKey) {
            UserDefaults.standard.set(legacyIDs, forKey: favouritesKey)
            UserDefaults.standard.removeObject(forKey: legacyFavouritesKey)
            return Set(legacyIDs)
        }

        let ids: [String] = []
        return Set(ids)
    }
}
