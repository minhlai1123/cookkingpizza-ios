import XCTest
@testable import PizzaCookingWorld

final class RecipeRepositoryTests: XCTestCase {

    func testRepository_containsExactlyTwentyRecipes() {
        let allRecipes = RecipeRepository.shared.getAllRecipes()
        XCTAssertEqual(allRecipes.count, 20, "Master recipe catalog must contain exactly 20 recipes")
    }

    func testRepository_recipeIdsAreUniqueAndInRangeR01ToR20() {
        let allRecipes = RecipeRepository.shared.getAllRecipes()
        let ids = allRecipes.map { $0.recipeId }
        let uniqueIds = Set(ids)

        XCTAssertEqual(uniqueIds.count, 20, "All recipe IDs must be unique")

        for i in 1...20 {
            let expectedId = String(format: "R-%02d", i)
            XCTAssertTrue(uniqueIds.contains(expectedId), "Recipe ID \(expectedId) must exist")
            let recipe = RecipeRepository.shared.getRecipeById(expectedId)
            XCTAssertNotNil(recipe, "Recipe for \(expectedId) must not be nil")
        }
    }

    func testRepository_noBakeRecipesCorrectlyIdentified() {
        let noBake = RecipeRepository.shared.getNoBakeRecipes()
        let noBakeIds = Set(noBake.map { $0.recipeId })

        XCTAssertTrue(noBakeIds.contains("R-03"), "R-03 (Summer Watermelon) must be no-bake")
        XCTAssertTrue(noBakeIds.contains("R-17"), "R-17 (Berry Tart) must be no-bake")

        let r01 = RecipeRepository.shared.getRecipeById("R-01")
        XCTAssertNotNil(r01)
        XCTAssertFalse(r01!.isNoBake, "R-01 must require baking")
        XCTAssertTrue(r01!.completionRules.requiresOven, "R-01 must require oven")
    }

    func testRepository_recipeDetailsArePopulated() {
        for recipe in RecipeRepository.shared.getAllRecipes() {
            XCTAssertFalse(recipe.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            XCTAssertFalse(recipe.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            XCTAssertTrue((1...5).contains(recipe.difficulty))
            XCTAssertFalse(recipe.toppingIds.isEmpty)
            XCTAssertFalse(recipe.toolIds.isEmpty)
        }
    }
}
