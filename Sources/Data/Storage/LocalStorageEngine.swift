import Foundation

public final class LocalStorageEngine {
    private let storageDir: URL
    private let fileName: String
    private let saveFileURL: URL
    private let backupFileURL: URL
    private let tempFileURL: URL

    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private let lock = NSLock()

    public init(storageDir: URL? = nil, fileName: String = "pizza_cooking_save.json") {
        if let dir = storageDir {
            self.storageDir = dir
        } else {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            self.storageDir = paths[0]
        }
        self.fileName = fileName
        self.saveFileURL = self.storageDir.appendingPathComponent(fileName)
        self.backupFileURL = self.storageDir.appendingPathComponent("\(fileName).bak")
        self.tempFileURL = self.storageDir.appendingPathComponent("\(fileName).tmp")

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.jsonEncoder = encoder
        self.jsonDecoder = JSONDecoder()
    }

    public func load() -> SaveData {
        lock.lock()
        defer { lock.unlock() }

        createDirectoryIfNeeded()

        if !FileManager.default.fileExists(atPath: saveFileURL.path) {
            let initial = createDefaultSaveData()
            _ = internalSave(initial)
            return initial
        }

        do {
            let data = try Data(contentsOf: saveFileURL)
            return try jsonDecoder.decode(SaveData.self, from: data)
        } catch {
            // Corruption detected, attempt restore from backup
            if let restored = tryRestoreFromBackup() {
                return restored
            }
            let fallback = createDefaultSaveData()
            _ = internalSave(fallback)
            return fallback
        }
    }

    public func save(_ data: SaveData) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        return internalSave(data)
    }

    private func internalSave(_ data: SaveData) -> Bool {
        createDirectoryIfNeeded()

        do {
            let encodedData = try jsonEncoder.encode(data)

            // Write to temporary file
            try encodedData.write(to: tempFileURL, options: .atomic)

            // Move temp to primary
            if FileManager.default.fileExists(atPath: saveFileURL.path) {
                _ = try? FileManager.default.removeItem(at: saveFileURL)
            }
            try FileManager.default.moveItem(at: tempFileURL, to: saveFileURL)

            // Update backup with verified valid save
            if FileManager.default.fileExists(atPath: backupFileURL.path) {
                _ = try? FileManager.default.removeItem(at: backupFileURL)
            }
            try FileManager.default.copyItem(at: saveFileURL, to: backupFileURL)

            return true
        } catch {
            return false
        }
    }

    public func updateRecipeScore(recipeId: String, stars: Int) -> Bool {
        var current = load()
        var currentProgress = current.recipesProgress[recipeId] ?? RecipeProgress(unlocked: true, stars: 0, timesCompleted: 0)
        currentProgress.stars = max(currentProgress.stars, stars)
        currentProgress.timesCompleted += 1
        current.recipesProgress[recipeId] = currentProgress
        return save(current)
    }

    public func incrementCreativeCount() -> Bool {
        var current = load()
        current.creativeModeStats.pizzasCreated += 1
        return save(current)
    }

    public func updateSettings(musicVolume: Float, sfxVolume: Float, hapticEnabled: Bool) -> Bool {
        var current = load()
        current.settings = SettingsData(
            musicVolume: min(max(musicVolume, 0.0), 1.0),
            sfxVolume: min(max(sfxVolume, 0.0), 1.0),
            hapticEnabled: hapticEnabled
        )
        return save(current)
    }

    public func resetData() -> Bool {
        let defaultData = createDefaultSaveData()
        return save(defaultData)
    }

    private func tryRestoreFromBackup() -> SaveData? {
        guard FileManager.default.fileExists(atPath: backupFileURL.path) else { return nil }
        do {
            let backupData = try Data(contentsOf: backupFileURL)
            let restored = try jsonDecoder.decode(SaveData.self, from: backupData)
            _ = internalSave(restored)
            return restored
        } catch {
            return nil
        }
    }

    public func createDefaultSaveData() -> SaveData {
        var defaultProgress: [String: RecipeProgress] = [:]
        for i in 1...20 {
            let id = String(format: "R-%02d", i)
            defaultProgress[id] = RecipeProgress(unlocked: true, stars: 0, timesCompleted: 0)
        }
        return SaveData(
            appVersion: "1.0.0",
            schemaVersion: 1,
            settings: SettingsData(),
            recipesProgress: defaultProgress,
            creativeModeStats: CreativeModeStats(pizzasCreated: 0)
        )
    }

    private func createDirectoryIfNeeded() {
        if !FileManager.default.fileExists(atPath: storageDir.path) {
            try? FileManager.default.createDirectory(at: storageDir, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
