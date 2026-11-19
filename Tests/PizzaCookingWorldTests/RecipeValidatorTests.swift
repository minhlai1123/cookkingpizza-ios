import XCTest
@testable import PizzaCookingWorld

final class RecipeValidatorTests: XCTestCase {

    func testValidator_allTwentyCatalogRecipesPass() {
        let allRecipes = RecipeRepository.shared.getAllRecipes()
        let result = RecipeValidator.shared.validateAllRecipes(allRecipes)
        XCTAssertTrue(result.isValid, "All 20 catalog recipes must be valid: \(result.errors)")
        XCTAssertTrue(result.errors.isEmpty)
    }

    func testValidator_catchesInvalidRecipeId() {
        guard let valid = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        let invalid = Recipe(
            recipeId: "R-99",
            name: valid.name,
            description: valid.description,
            category: valid.category,
            difficulty: valid.difficulty,
            isNoBake: valid.isNoBake,
            crustId: valid.crustId,
            sauceId: valid.sauceId,
            cheeseId: valid.cheeseId,
            toppingIds: valid.toppingIds,
            toolIds: valid.toolIds,
            specialMechanics: valid.specialMechanics,
            completionRules: valid.completionRules,
            presentationMetadata: valid.presentationMetadata
        )
        let result = RecipeValidator.shared.validateRecipe(invalid)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.contains("Invalid recipeId format") })
    }

    func testValidator_catchesNonExistentCrust() {
        guard let valid = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        let invalid = Recipe(
            recipeId: valid.recipeId,
            name: valid.name,
            description: valid.description,
            category: valid.category,
            difficulty: valid.difficulty,
            isNoBake: valid.isNoBake,
            crustId: "ING-999",
            sauceId: valid.sauceId,
            cheeseId: valid.cheeseId,
            toppingIds: valid.toppingIds,
            toolIds: valid.toolIds,
            specialMechanics: valid.specialMechanics,
            completionRules: valid.completionRules,
            presentationMetadata: valid.presentationMetadata
        )
        let result = RecipeValidator.shared.validateRecipe(invalid)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.contains("Crust ING-999 does not exist") })
    }

    func testValidator_catchesInvalidDifficulty() {
        guard let valid = RecipeRepository.shared.getRecipeById("R-01") else {
            XCTFail("R-01 not found")
            return
        }
        let invalid = Recipe(
            recipeId: valid.recipeId,
            name: valid.name,
            description: valid.description,
            category: valid.category,
            difficulty: 9,
            isNoBake: valid.isNoBake,
            crustId: valid.crustId,
            sauceId: valid.sauceId,
            cheeseId: valid.cheeseId,
            toppingIds: valid.toppingIds,
            toolIds: valid.toolIds,
            specialMechanics: valid.specialMechanics,
            completionRules: valid.completionRules,
            presentationMetadata: valid.presentationMetadata
        )
        let result = RecipeValidator.shared.validateRecipe(invalid)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.contains("difficulty must be between 1 and 5") })
    }

    func testValidator_catchesNoBakeInconsistency() {
        guard let valid = RecipeRepository.shared.getRecipeById("R-03") else {
            XCTFail("R-03 not found")
            return
        }
        XCTAssertTrue(valid.isNoBake)

        let inconsistentRules = CompletionRules(
            minSauceCoverage: valid.completionRules.minSauceCoverage,
            minToppings: valid.completionRules.minToppings,
            requiresOven: true
        )
        let invalid = Recipe(
            recipeId: valid.recipeId,
            name: valid.name,
            description: valid.description,
            category: valid.category,
            difficulty: valid.difficulty,
            isNoBake: true,
            crustId: valid.crustId,
            sauceId: valid.sauceId,
            cheeseId: valid.cheeseId,
            toppingIds: valid.toppingIds,
            toolIds: valid.toolIds,
            specialMechanics: valid.specialMechanics,
            completionRules: inconsistentRules,
            presentationMetadata: valid.presentationMetadata
        )
        let result = RecipeValidator.shared.validateRecipe(invalid)
        XCTAssertFalse(result.isValid)
        XCTAssertTrue(result.errors.contains { $0.contains("cannot have requiresOven = true") })
    }
}
