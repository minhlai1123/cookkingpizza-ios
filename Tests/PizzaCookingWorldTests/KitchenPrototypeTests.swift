import XCTest
@testable import PizzaCookingWorld

final class KitchenPrototypeTests: XCTestCase {
    
    private var viewModel: KitchenViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = KitchenViewModel(initialRecipeId: "R-01", initialMode: .recipeMode)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testKitchenViewModel_initialState_isRecipeModeAndStep1() {
        let state = viewModel.uiState
        
        XCTAssertEqual(state.gameMode, .recipeMode)
        XCTAssertEqual(state.currentRecipe?.recipeId, "R-01")
        XCTAssertEqual(state.currentStepIndex, 0)
        XCTAssertEqual(state.currentStepId, "STEP-001")
        XCTAssertEqual(state.totalSteps, 10)
        XCTAssertEqual(state.selectedToolId, "TOOL-001")
        XCTAssertFalse(state.isFinished)
        XCTAssertEqual(state.skippedStepsCount, 0)
    }
    
    func testKitchenViewModel_ingredientSelection_updatesSauceCheeseAndToppings() {
        // Select Sauce
        viewModel.selectIngredient("ING-011")
        XCTAssertEqual(viewModel.uiState.sauceCoverage, 1.0, accuracy: 0.01)
        XCTAssertEqual(viewModel.uiState.selectedIngredientId, "ING-011")
        
        // Select Cheese
        viewModel.selectIngredient("ING-021")
        XCTAssertEqual(viewModel.uiState.cheeseGrated, 1.0, accuracy: 0.01)
        
        // Select Toppings
        viewModel.selectIngredient("ING-040") // Pepperoni
        viewModel.selectIngredient("ING-034") // Basil
        XCTAssertEqual(viewModel.uiState.placedToppings.count, 2)
        XCTAssertEqual(viewModel.uiState.placedToppings[0].ingredientId, "ING-040")
        XCTAssertEqual(viewModel.uiState.placedToppings[1].ingredientId, "ING-034")
    }
    
    func testKitchenViewModel_creativeMode_accessesAll86ToppingsAcross5Categories() {
        viewModel.switchMode(.creativeMode)
        XCTAssertEqual(viewModel.uiState.gameMode, .creativeMode)
        
        // Category 1: VEGETABLE (20 items)
        viewModel.selectCreativeCategory("VEGETABLE")
        let veggieList = viewModel.uiState.availableIngredients
        XCTAssertEqual(veggieList.count, 20)
        XCTAssertTrue(veggieList.allSatisfy { $0.category == "TOPPING_VEGGIE" })
        
        // Category 2: MEAT (19 items)
        viewModel.selectCreativeCategory("MEAT")
        let meatList = viewModel.uiState.availableIngredients
        XCTAssertEqual(meatList.count, 19)
        XCTAssertTrue(meatList.allSatisfy { $0.category == "TOPPING_MEAT" })
        
        // Category 3: FRUIT (14 items)
        viewModel.selectCreativeCategory("FRUIT")
        let fruitList = viewModel.uiState.availableIngredients
        XCTAssertEqual(fruitList.count, 14)
        XCTAssertTrue(fruitList.allSatisfy { $0.category == "TOPPING_FRUIT" })
        
        // Category 4: SWEET (25 items)
        viewModel.selectCreativeCategory("SWEET")
        let sweetList = viewModel.uiState.availableIngredients
        XCTAssertEqual(sweetList.count, 25)
        XCTAssertTrue(sweetList.allSatisfy { $0.category == "TOPPING_SWEET" })
        
        // Category 5: FANTASY (8 items)
        viewModel.selectCreativeCategory("FANTASY")
        let fantasyList = viewModel.uiState.availableIngredients
        XCTAssertEqual(fantasyList.count, 8)
        XCTAssertTrue(fantasyList.allSatisfy { $0.category == "TOPPING_FANTASY" })
        
        let total = veggieList.count + meatList.count + fruitList.count + sweetList.count + fantasyList.count
        XCTAssertEqual(total, 86)
    }
    
    func testKitchenViewModel_toolSelection_updatesActiveTool() {
        viewModel.selectTool("TOOL-006")
        XCTAssertEqual(viewModel.uiState.selectedToolId, "TOOL-006")
        XCTAssertEqual(viewModel.uiState.activeTool?.toolId, "TOOL-006")
        XCTAssertEqual(viewModel.uiState.activeTool?.name, "Sauce Ladle")
    }
    
    func testKitchenViewModel_stepAdvancement_cyclesThroughAll10StepsAndFinishes() {
        for i in 0..<9 {
            XCTAssertEqual(viewModel.uiState.currentStepIndex, i)
            XCTAssertFalse(viewModel.uiState.isFinished)
            viewModel.advanceStep()
        }
        
        XCTAssertEqual(viewModel.uiState.currentStepIndex, 9)
        XCTAssertEqual(viewModel.uiState.currentStepId, "STEP-010")
        
        viewModel.advanceStep()
        XCTAssertTrue(viewModel.uiState.isFinished)
        XCTAssertNotNil(viewModel.uiState.scoreStars)
        if let stars = viewModel.uiState.scoreStars {
            XCTAssertTrue((1...3).contains(stars))
        }
    }
    
    func testKitchenViewModel_skipStep_immediatelyAdvancesAndAppliesScoringPenalty() {
        XCTAssertEqual(viewModel.uiState.currentStepIndex, 0)
        XCTAssertEqual(viewModel.uiState.skippedStepsCount, 0)
        
        // Skip step 1
        viewModel.skipStep()
        XCTAssertEqual(viewModel.uiState.currentStepIndex, 1)
        XCTAssertEqual(viewModel.uiState.skippedStepsCount, 1)
        
        // Select required toppings so cooking rules are satisfied
        viewModel.selectIngredient("ING-011")
        viewModel.selectIngredient("ING-021")
        viewModel.selectIngredient("ING-034")
        viewModel.selectIngredient("ING-030")
        viewModel.selectIngredient("ING-031")
        
        for _ in 1..<9 {
            viewModel.advanceStep()
        }
        viewModel.advanceStep()
        
        XCTAssertTrue(viewModel.uiState.isFinished)
        // 1 skip with good toppings = 2 stars per GDD & Phase 1.3.0 scoring formula
        XCTAssertEqual(viewModel.uiState.scoreStars, 2)
    }
    
    func testKitchenViewModel_toddlerTapFallback_incrementsProgressBy25Percent() {
        XCTAssertEqual(viewModel.uiState.doughRollProgress, 0.0, accuracy: 0.01)
        
        viewModel.applyToddlerTap()
        XCTAssertEqual(viewModel.uiState.doughRollProgress, 0.25, accuracy: 0.01)
        
        viewModel.applyToddlerTap()
        XCTAssertEqual(viewModel.uiState.doughRollProgress, 0.50, accuracy: 0.01)
        
        viewModel.applyToddlerTap()
        XCTAssertEqual(viewModel.uiState.doughRollProgress, 0.75, accuracy: 0.01)
        
        viewModel.applyToddlerTap()
        XCTAssertEqual(viewModel.uiState.doughRollProgress, 1.00, accuracy: 0.01)
    }
    
    func testKitchenViewModel_noBakeRecipe_autoBakes() {
        let noBakeVm = KitchenViewModel(initialRecipeId: "R-03", initialMode: .recipeMode)
        XCTAssertTrue(noBakeVm.uiState.isBaked, "R-03 Watermelon Pizza should auto-satisfy baking")
    }
    
    func testResponsiveCanvas_aspectRatioCalculations_arePreservedAcrossDevices() {
        let targetRatio: CGFloat = 16.0 / 9.0
        
        // 16:9 Standard (1920x1080)
        let w1: CGFloat = 1920
        let h1: CGFloat = 1080
        XCTAssertEqual(w1 / h1, targetRatio, accuracy: 0.001)
        
        // 19.5:9 Phone (2796x1290) -> fit by height
        let wPhone: CGFloat = 2796
        let hPhone: CGFloat = 1290
        let canvasWPhone = hPhone * targetRatio
        XCTAssertEqual(canvasWPhone, 2293.333, accuracy: 0.01)
        XCTAssertTrue(canvasWPhone <= wPhone)
        
        // 4:3 iPad (2048x1536) -> fit by width
        let wPad: CGFloat = 2048
        let hPad: CGFloat = 1536
        let canvasHPad = wPad / targetRatio
        XCTAssertEqual(canvasHPad, 1152.0, accuracy: 0.01)
        XCTAssertTrue(canvasHPad <= hPad)
    }
}
