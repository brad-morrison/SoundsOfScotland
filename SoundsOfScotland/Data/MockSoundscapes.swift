import Foundation

enum MockSoundscapes {
    static let all: [Soundscape] = [
        Soundscape(
            id: "loch-ness-shores",
            title: "Loch Ness Shores",
            subtitle: "Highlands",
            description: "Gentle waves, distant birds, and the quiet mystery of the loch.",
            imageName: "loch_ness",
            audioFileName: "loch_ness",
            category: .island,
            isPremium: false,
            isComingSoon: false
        ),
        Soundscape(
            id: "tentsmuir-forest",
            title: "Tentsmuir Forest",
            subtitle: "Fife",
            description: "Wind through tall pines, soft woodland ambience, and coastal calm.",
            imageName: "tentsmuir_forest",
            audioFileName: "loch_ness",
            category: .forest,
            isPremium: false,
            isComingSoon: false
        ),
        Soundscape(
            id: "fairy-pools",
            title: "Fairy Pools",
            subtitle: "Isle of Skye",
            description: "Crystal water, mountain air, and the flowing streams of Skye.",
            imageName: "fairy_pools",
            audioFileName: "loch_ness",
            category: .mountain,
            isPremium: true,
            isComingSoon: false
        ),
        Soundscape(
            id: "edinburgh-festival",
            title: "Edinburgh Festival",
            subtitle: "Edinburgh",
            description: "A warm city atmosphere with distant crowds, street performers, and summer energy.",
            imageName: "edinburgh_festival",
            audioFileName: "loch_ness",
            category: .city,
            isPremium: true,
            isComingSoon: false
        ),
        Soundscape(
            id: "stormy-west-sands",
            title: "Stormy West Sands",
            subtitle: "St Andrews",
            description: "Rolling waves, coastal wind, and a dramatic Scottish shoreline.",
            imageName: "stormy_west_sands",
            audioFileName: "loch_ness",
            category: .beach,
            isPremium: false,
            isComingSoon: false
        ),
        Soundscape(
            id: "glencoe-valley",
            title: "Glencoe Valley",
            subtitle: "Glencoe",
            description: "A vast Highland soundscape with wind, rain, and distant open space.",
            imageName: "glencoe_valley",
            audioFileName: "loch_ness",
            category: .mountain,
            isPremium: true,
            isComingSoon: false
        )
    ]
}
