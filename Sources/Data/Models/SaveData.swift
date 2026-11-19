import Foundation

public struct SettingsData: Codable, Equatable {
    public var musicVolume: Float
    public var sfxVolume: Float
    public var hapticEnabled: Bool

    public init(
        musicVolume: Float = 0.8,
        sfxVolume: Float = 1.0,
        hapticEnabled: Bool = true
    ) {
        self.musicVolume = musicVolume
        self.sfxVolume = sfxVolume
        self.hapticEnabled = hapticEnabled
    }
}

public struct RecipeProgress: Codable, Equatable {
    public var unlocked: Bool
    public var stars: Int
    public var timesCompleted: Int

    public init(
        unlocked: Bool = true,
        stars: Int = 0,
        timesCompleted: Int = 0
    ) {
        self.unlocked = unlocked
        self.stars = stars
        self.timesCompleted = timesCompleted
    }
}

public struct CreativeModeStats: Codable, Equatable {
    public var pizzasCreated: Int

    public init(pizzasCreated: Int = 0) {
        self.pizzasCreated = pizzasCreated
    }
}

public struct SaveData: Codable, Equatable {
    public var appVersion: String
    public var schemaVersion: Int
    public var settings: SettingsData
    public var recipesProgress: [String: RecipeProgress]
    public var creativeModeStats: CreativeModeStats

    public init(
        appVersion: String = "1.0.0",
        schemaVersion: Int = 1,
        settings: SettingsData = SettingsData(),
        recipesProgress: [String: RecipeProgress] = [:],
        creativeModeStats: CreativeModeStats = CreativeModeStats()
    ) {
        self.appVersion = appVersion
        self.schemaVersion = schemaVersion
        self.settings = settings
        self.recipesProgress = recipesProgress
        self.creativeModeStats = creativeModeStats
    }
}
