import XCTest
@testable import PizzaCookingWorld

final class LocalStorageEngineTests: XCTestCase {

    var tempDirectory: URL!
    var engine: LocalStorageEngine!

    override func setUp() {
        super.setUp()
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try? FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
        engine = LocalStorageEngine(storageDir: tempDirectory)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDirectory)
        super.tearDown()
    }

    func testLocalStorage_createsDefaultSaveDataWithAllTwentyRecipesUnlocked() {
        let data = engine.load()
        XCTAssertEqual(data.appVersion, "1.0.0")
        XCTAssertEqual(data.schemaVersion, 1)
        XCTAssertEqual(data.recipesProgress.count, 20)

        for i in 1...20 {
            let id = String(format: "R-%02d", i)
            let progress = data.recipesProgress[id]
            XCTAssertNotNil(progress, "Recipe progress for \(id) must exist")
            XCTAssertTrue(progress?.unlocked ?? false, "Recipe \(id) must be unlocked by default")
            XCTAssertEqual(progress?.stars, 0)
        }
    }

    func testLocalStorage_updatesRecipeScoreAndTimesCompleted() {
        _ = engine.load()
        XCTAssertTrue(engine.updateRecipeScore(recipeId: "R-01", stars: 3))

        let loaded = engine.load()
        let r01 = loaded.recipesProgress["R-01"]
        XCTAssertEqual(r01?.stars, 3)
        XCTAssertEqual(r01?.timesCompleted, 1)

        // Lower score does not overwrite higher score
        _ = engine.updateRecipeScore(recipeId: "R-01", stars: 2)
        let loadedAgain = engine.load()
        XCTAssertEqual(loadedAgain.recipesProgress["R-01"]?.stars, 3)
        XCTAssertEqual(loadedAgain.recipesProgress["R-01"]?.timesCompleted, 2)
    }

    func testLocalStorage_incrementsCreativeCount() {
        _ = engine.load()
        XCTAssertEqual(engine.load().creativeModeStats.pizzasCreated, 0)

        XCTAssertTrue(engine.incrementCreativeCount())
        XCTAssertTrue(engine.incrementCreativeCount())

        XCTAssertEqual(engine.load().creativeModeStats.pizzasCreated, 2)
    }

    func testLocalStorage_atomicWriteCreatesBackup() {
        _ = engine.load()
        XCTAssertTrue(engine.updateRecipeScore(recipeId: "R-02", stars: 2))

        let mainFile = tempDirectory.appendingPathComponent("pizza_cooking_save.json")
        let backupFile = tempDirectory.appendingPathComponent("pizza_cooking_save.json.bak")

        XCTAssertTrue(FileManager.default.fileExists(atPath: mainFile.path))
        XCTAssertTrue(FileManager.default.fileExists(atPath: backupFile.path))
    }

    func testLocalStorage_recoversFromCorruptedPrimaryFileUsingBackup() {
        _ = engine.load()
        _ = engine.updateRecipeScore(recipeId: "R-05", stars: 3)

        let mainFile = tempDirectory.appendingPathComponent("pizza_cooking_save.json")
        try? "{ malformed corrupted json".write(to: mainFile, atomically: true, encoding: .utf8)

        let recovered = engine.load()
        let r05 = recovered.recipesProgress["R-05"]
        XCTAssertEqual(r05?.stars, 3, "Recovered data must preserve R-05 stars")
    }

    func testLocalStorage_fallsBackToCleanDefaultsIfBothFilesCorrupted() {
        _ = engine.load()
        _ = engine.updateRecipeScore(recipeId: "R-05", stars: 3)

        let mainFile = tempDirectory.appendingPathComponent("pizza_cooking_save.json")
        let backupFile = tempDirectory.appendingPathComponent("pizza_cooking_save.json.bak")

        try? "corrupted".write(to: mainFile, atomically: true, encoding: .utf8)
        try? "corrupted".write(to: backupFile, atomically: true, encoding: .utf8)

        let safeFallback = engine.load()
        XCTAssertEqual(safeFallback.recipesProgress.count, 20)
    }
}
