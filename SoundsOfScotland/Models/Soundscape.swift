import Foundation

struct Soundscape: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let audioFileName: String
    let category: SoundscapeCategory
    let isPremium: Bool
    let isComingSoon: Bool
}

enum SoundscapeCategory: String, CaseIterable {
    case beach
    case forest
    case city
    case mountain
    case island
    case meadow
}

