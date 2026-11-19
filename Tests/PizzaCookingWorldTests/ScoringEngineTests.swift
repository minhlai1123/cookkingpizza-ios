import XCTest
@testable import PizzaCookingWorld

final class ScoringEngineTests: XCTestCase {

    func testScoring_perfectRecipeExecution_awardsThreeStars() {
        guard let recipe = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        let session = CookingSession(recipe: recipe)
        session.startSession()

        while !session.isFinished {
            session.completeCurrentStep(manual: true)
            session.moveToNextStep()
        }

        session.recordSauceCoverage(0.85)
        session.addTopping(ingredientId: "ING-030", x: 0.5, y: 0.5)
        session.addTopping(ingredientId: "ING-030", x: 0.3, y: 0.4)
        session.addTopping(ingredientId: "ING-030", x: 0.7, y: 0.6)
        session.completeBaking()

        let result = ScoringEngine.shared.calculateRecipeScore(session: session)
        XCTAssertEqual(result.stars, 3, "Perfect manual execution must award 3 stars")
        XCTAssertTrue(result.feedbackMessage.contains("Master Chef"))
    }

    func testScoring_noBakeRecipe_autoPassesOvenRequirement() {
        guard let noBakeRecipe = RecipeRepository.shared.getRecipeById("R-03") else {
            XCTFail("R-03 not found")
            return
        }
        XCTAssertTrue(noBakeRecipe.isNoBake)

        let session = CookingSession(recipe: noBakeRecipe)
        session.startSession()

        while !session.isFinished {
            session.completeCurrentStep(manual: true)
            session.moveToNextStep()
        }

        session.recordSauceCoverage(0.85)
        session.addTopping(ingredientId: "ING-050", x: 0.5, y: 0.5)
        session.addTopping(ingredientId: "ING-051", x: 0.3, y: 0.4)
        session.addTopping(ingredientId: "ING-052", x: 0.7, y: 0.6)
        session.addTopping(ingredientId: "ING-063", x: 0.2, y: 0.8)

        let result = ScoringEngine.shared.calculateRecipeScore(session: session)
        XCTAssertEqual(result.stars, 3, "No-bake recipe must award 3 stars without baking")
        XCTAssertTrue(result.isOvenPassed)
    }

    func testScoring_minorSkips_awardsTwoStars() {
        guard let recipe = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        let session = CookingSession(recipe: recipe)
        session.startSession()

        session.completeCurrentStep(manual: false) // 1 skip
        session.moveToNextStep()

        while !session.isFinished {
            session.completeCurrentStep(manual: true)
            session.moveToNextStep()
        }

        session.recordSauceCoverage(0.65)
        session.addTopping(ingredientId: "ING-030", x: 0.5, y: 0.5)
        session.addTopping(ingredientId: "ING-030", x: 0.3, y: 0.4)
        session.addTopping(ingredientId: "ING-030", x: 0.7, y: 0.6)

        let result = ScoringEngine.shared.calculateRecipeScore(session: session)
        XCTAssertEqual(result.stars, 2, "Minor skip should award 2 stars")
    }

    func testScoring_neverAwardsZeroStars() {
        guard let recipe = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        let session = CookingSession(recipe: recipe)
        session.startSession()

        while !session.isFinished {
            session.completeCurrentStep(manual: false)
            session.moveToNextStep()
        }

        let result = ScoringEngine.shared.calculateRecipeScore(session: session)
        XCTAssertEqual(result.stars, 1, "Minimum score must be 1 star (never 0 stars)")
    }

    func testScoring_creativeMode_alwaysAwardsThreeStars() {
        let session = CreativeCookingSession()
        session.selectCrust("ING-001")
        session.selectSauce("ING-011")
        session.addTopping(ingredientId: "ING-030", x: 0.5, y: 0.5)
        session.finishCreativePizza()

        let result = ScoringEngine.shared.calculateCreativeScore(session: session)
        XCTAssertEqual(result.stars, 3, "Creative mode must always award 3 stars")
    }
}
