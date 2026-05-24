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
    private let favouritesKey = "favouriteSoundscapeIDs"

    init() {
        favouriteSoundscapeIDs = loadFavouriteSoundscapeIDs()

        audioPlayer.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        NotificationCenter.default.addObserver(forName: .authStateChanged, object: nil, queue: .main) { [weak self] _ in
            self?.currentUser = AuthService.shared.currentUser
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
        if favouriteSoundscapeIDs.contains(soundscape.id) {
            favouriteSoundscapeIDs.remove(soundscape.id)
        } else {
            favouriteSoundscapeIDs.insert(soundscape.id)
        }
    }

    private func saveFavouriteSoundscapeIDs() {
        let ids = Array(favouriteSoundscapeIDs)
        UserDefaults.standard.set(ids, forKey: favouritesKey)
    }

    private func loadFavouriteSoundscapeIDs() -> Set<String> {
        let ids = UserDefaults.standard.stringArray(forKey: favouritesKey) ?? []
        return Set(ids)
    }
}
