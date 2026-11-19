import XCTest
@testable import PizzaCookingWorld

final class RecipeMenuAndDifficultyTests: XCTestCase {

    func testAll20Recipes_areRegisteredInMetadataWithValidTiers() {
        let allRecipes = RecipeRepository.shared.getAllRecipes()
        XCTAssertEqual(allRecipes.count, 20, "Master catalog must contain exactly 20 recipes")
        
        for recipe in allRecipes {
            let info = RecipeMetadataRegistry.getInfo(for: recipe.recipeId)
            XCTAssertEqual(info.recipeId, recipe.recipeId)
            XCTAssertFalse(info.nameVi.isEmpty, "Vietnamese name must not be blank for \(recipe.recipeId)")
            XCTAssertFalse(info.nameEn.isEmpty, "English name must not be blank for \(recipe.recipeId)")
            XCTAssertFalse(info.descriptionVi.isEmpty, "Description must not be blank for \(recipe.recipeId)")
            XCTAssertTrue((1...3).contains(info.difficultyTier), "Difficulty tier must be between 1 and 3")
            XCTAssertTrue(info.difficultyLabelVi.contains("⭐"), "Badge label must contain star icon")
        }
    }

    func testRecipeDifficultyTiers_areCorrectlyPartitioned() {
        let allRecipes = RecipeRepository.shared.getAllRecipes()
        
        let easyRecipes = allRecipes.filter { RecipeMetadataRegistry.getInfo(for: $0.recipeId).difficultyTier == 1 }
        let mediumRecipes = allRecipes.filter { RecipeMetadataRegistry.getInfo(for: $0.recipeId).difficultyTier == 2 }
        let hardRecipes = allRecipes.filter { RecipeMetadataRegistry.getInfo(for: $0.recipeId).difficultyTier == 3 }
        
        XCTAssertEqual(easyRecipes.count, 6, "Easy tier must have 6 recipes")
        XCTAssertEqual(mediumRecipes.count, 9, "Medium tier must have 9 recipes")
        XCTAssertEqual(hardRecipes.count, 5, "Hard tier must have 5 recipes")
        XCTAssertEqual(easyRecipes.count + mediumRecipes.count + hardRecipes.count, 20)
        
        let noBakeRecipes = allRecipes.filter { $0.isNoBake }
        XCTAssertEqual(noBakeRecipes.count, 2, "No-Bake category must contain exactly 2 recipes")
        XCTAssertTrue(noBakeRecipes.contains { $0.recipeId == "R-03" })
        XCTAssertTrue(noBakeRecipes.contains { $0.recipeId == "R-17" })
    }

    func testKitchenViewModel_setsDifficultyTierFromRecipe() {
        let vmEasy = KitchenViewModel(initialRecipeId: "R-01")
        XCTAssertEqual(vmEasy.uiState.difficultyTier, 1)
        
        let r07 = RecipeRepository.shared.getRecipeById("R-07")!
        vmEasy.startRecipeCooking(recipe: r07)
        XCTAssertEqual(vmEasy.uiState.difficultyTier, 2)
        
        let r20 = RecipeRepository.shared.getRecipeById("R-20")!
        vmEasy.startRecipeCooking(recipe: r20)
        XCTAssertEqual(vmEasy.uiState.difficultyTier, 3)
    }

    func testGameplayProgressIncrements_scaleWithDifficulty() {
        // Easy Mode
        let vmEasy = KitchenViewModel(initialRecipeId: "R-01")
        XCTAssertEqual(vmEasy.uiState.difficultyTier, 1)
        vmEasy.interactDough()
        XCTAssertEqual(vmEasy.uiState.doughRollProgress, 0.35, accuracy: 0.01)
        
        // Hard Mode
        let vmHard = KitchenViewModel(initialRecipeId: "R-20")
        XCTAssertEqual(vmHard.uiState.difficultyTier, 3)
        vmHard.interactDough()
        XCTAssertEqual(vmHard.uiState.doughRollProgress, 0.16, accuracy: 0.01)
    }
}
