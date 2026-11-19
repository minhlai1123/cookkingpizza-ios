import XCTest
@testable import PizzaCookingWorld

final class GameStateMachineTests: XCTestCase {

    func testStateMachine_initialStateIsSplash() {
        let sm = GameStateMachine()
        XCTAssertEqual(sm.currentScreen, .splash)
        XCTAssertNil(sm.currentMode)
        XCTAssertNil(sm.activeCookingSession)
    }

    func testStateMachine_validLinearTransitionsSucceed() {
        let sm = GameStateMachine()
        XCTAssertTrue(sm.transition(to: .mainMenu))
        XCTAssertEqual(sm.currentScreen, .mainMenu)

        XCTAssertTrue(sm.transition(to: .recipeSelection))
        XCTAssertEqual(sm.currentScreen, .recipeSelection)

        guard let recipe = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        XCTAssertTrue(sm.startRecipe(recipe))
        XCTAssertEqual(sm.currentScreen, .recipePreparation)
        XCTAssertEqual(sm.currentMode, .recipeMode)
        XCTAssertNotNil(sm.activeCookingSession)
    }

    func testStateMachine_illegalTransitionsAreRejected() {
        let sm = GameStateMachine()
        XCTAssertFalse(sm.transition(to: .bakingOven))
        XCTAssertEqual(sm.currentScreen, .splash)

        sm.transition(to: .mainMenu)
        XCTAssertFalse(sm.transition(to: .resultEvaluation))
        XCTAssertEqual(sm.currentScreen, .mainMenu)
    }

    func testStateMachine_stepAdvancementAndSkipFlow() {
        let sm = GameStateMachine(initialScreen: .mainMenu)
        sm.transition(to: .recipeSelection)
        guard let recipe = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        sm.startRecipe(recipe)

        guard let session = sm.activeCookingSession else {
            XCTFail("Session should not be nil")
            return
        }
        XCTAssertEqual(session.currentStepIndex, 0)

        XCTAssertTrue(sm.skipCurrentStep())
        XCTAssertEqual(session.skippedStepsCount, 1)
    }

    func testStateMachine_toddlerTapFallbackAddsProgress() {
        let sm = GameStateMachine(initialScreen: .mainMenu)
        sm.transition(to: .recipeSelection)
        guard let recipe = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        sm.startRecipe(recipe)

        guard let session = sm.activeCookingSession else {
            XCTFail("Session should not be nil")
            return
        }
        XCTAssertEqual(session.toddlerTapCount, 0)
        XCTAssertEqual(session.currentStepProgress, 0.0, accuracy: 0.001)

        sm.applyToddlerTap()
        XCTAssertEqual(session.toddlerTapCount, 1)
        XCTAssertEqual(session.currentStepProgress, 0.25, accuracy: 0.001)

        sm.applyToddlerTap()
        sm.applyToddlerTap()
        XCTAssertEqual(session.currentStepProgress, 0.75, accuracy: 0.001)
    }

    func testStateMachine_antiDoubleScoringPreventsRepeatedEvaluation() {
        let sm = GameStateMachine(initialScreen: .mainMenu)
        sm.transition(to: .recipeSelection)
        guard let recipe = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        sm.startRecipe(recipe)

        while !(sm.activeCookingSession?.isFinished ?? true) {
            sm.activeCookingSession?.completeCurrentStep(manual: true)
            sm.advanceCookingStep()
        }

        let result1 = sm.finishSession()
        XCTAssertNotNil(result1)
        XCTAssertEqual(sm.currentScreen, .resultEvaluation)

        let result2 = sm.finishSession()
        XCTAssertNotNil(result2)
        XCTAssertEqual(result1, result2, "Subsequent finishSession call must return identical cached result")
    }
}
