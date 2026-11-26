import Foundation
import SwiftUI
import Combine

public class KitchenViewModel: ObservableObject {
    @Published public var uiState: KitchenUiState = KitchenUiState()
    
    private let stateMachine = GameStateMachine()
    
    private struct StepInfo {
        let id: String
        let title: String
        let prompt: String
        let toolId: String?
    }
    
    private let stepDefinitions: [StepInfo] = [
        StepInfo(id: "STEP-001", title: "Dough Kneading", prompt: "Tap and punch the dough ball!", toolId: "TOOL-001"),
        StepInfo(id: "STEP-002", title: "Dough Rolling", prompt: "Swipe to roll and flatten the dough!", toolId: "TOOL-001"),
        StepInfo(id: "STEP-003", title: "Dough Cutting", prompt: "Stamp the crust into shape!", toolId: "TOOL-012"),
        StepInfo(id: "STEP-004", title: "Sauce Blending", prompt: "Hold or tap to blend fresh sauce!", toolId: "TOOL-003"),
        StepInfo(id: "STEP-005", title: "Crust Shaping", prompt: "Pinch delicious stuffed crust edges!", toolId: "TOOL-001"),
        StepInfo(id: "STEP-006", title: "Sauce Spreading", prompt: "Swirl rich sauce across the pizza base!", toolId: "TOOL-006"),
        StepInfo(id: "STEP-007", title: "Cheese Grating", prompt: "Grate fresh cheese over the sauce!", toolId: "TOOL-005"),
        StepInfo(id: "STEP-008", title: "Topping Decorating", prompt: "Pick toppings from the shelf and place them!", toolId: nil),
        StepInfo(id: "STEP-009", title: "Oven Baking", prompt: "Slide pizza into the oven to bake golden!", toolId: "TOOL-007"),
        StepInfo(id: "STEP-010", title: "Slicing & Eating", prompt: "Slice your pizza and tap to take bites!", toolId: "TOOL-008")
    ]
    
    public init(initialRecipeId: String = "R-01", initialMode: GameMode = .recipeMode) {
        let recipe = RecipeRepository.shared.getRecipeById(initialRecipeId) ?? RecipeRepository.shared.getAllRecipes().first!
        initSession(recipe: recipe, mode: initialMode)
    }
    
    public func initSession(recipe: Recipe, mode: GameMode) {
        if mode == .recipeMode {
            _ = stateMachine.startRecipe(recipe)
        } else {
            _ = stateMachine.startCreativeMode()
        }
        
        let step = stepDefinitions[0]
        let availableIngs = getIngredientsForStep(mode: mode, stepId: step.id, recipe: recipe, creativeCategory: "VEGETABLE")
        let activeTool = step.toolId.flatMap { ToolRepository.shared.getToolById($0) }
        
        let tier: Int
        if recipe.difficulty <= 2 {
            tier = 1
        } else if recipe.difficulty == 3 {
            tier = 2
        } else {
            tier = 3
        }
        
        var newState = KitchenUiState()
        newState.gameMode = mode
        newState.currentRecipe = recipe
        newState.difficultyTier = tier
        newState.currentStepIndex = 0
        newState.totalSteps = 10
        newState.currentStepId = step.id
        newState.currentStepTitle = step.title
        newState.currentStepPrompt = step.prompt
        newState.selectedIngredientId = nil
        newState.selectedToolId = step.toolId
        newState.activeCreativeCategory = "VEGETABLE"
        newState.availableIngredients = availableIngs
        newState.activeTool = activeTool
        newState.placedToppings = []
        newState.sauceCoverage = 0.0
        newState.cheeseGrated = 0.0
        newState.doughRollProgress = 0.0
        newState.isBaked = recipe.isNoBake
        newState.ovenHeatProgress = recipe.isNoBake ? 1.0 : 0.0
        newState.slicesCount = 0
        newState.bitesCount = 0
        newState.isAudioMuted = false
        newState.skippedStepsCount = 0
        newState.isFinished = false
        newState.scoreStars = nil
        newState.feedbackMessage = "Ready to cook: \(recipe.name)!"
        
        self.uiState = newState
    }
    
    public func startRecipeCooking(recipe: Recipe) {
        initSession(recipe: recipe, mode: .recipeMode)
    }
    
    public func switchMode(_ mode: GameMode) {
        let currentRecipe = uiState.currentRecipe ?? RecipeRepository.shared.getAllRecipes().first!
        initSession(recipe: currentRecipe, mode: mode)
    }
    
    public func selectCreativeCategory(_ category: String) {
        let ingredients = getCreativeIngredientsForCategory(category)
        uiState.activeCreativeCategory = category
        uiState.availableIngredients = ingredients
        uiState.feedbackMessage = "Browsing category: \(category)"
    }
    
    public func selectIngredient(_ ingredientId: String) {
        guard let ingredient = IngredientRepository.shared.getIngredientById(ingredientId) else { return }
        
        uiState.selectedIngredientId = ingredientId
        
        if ingredient.category == "SAUCE" {
            uiState.sauceCoverage = 1.0
            stateMachine.activeCookingSession?.recordSauceCoverage(1.0)
            _ = stateMachine.activeCreativeSession?.selectSauce(ingredientId)
        } else if ingredient.category == "CHEESE" {
            uiState.cheeseGrated = 1.0
            _ = stateMachine.activeCreativeSession?.selectCheese(ingredientId)
        } else if ingredient.category.hasPrefix("TOPPING") {
            let angle = Double.random(in: 0.0...(2.0 * .pi))
            let r = Float.random(in: 0.1...0.75)
            let posX = 0.5 + r * Float(cos(angle))
            let posY = 0.5 + r * Float(sin(angle))
            
            if uiState.placedToppings.count < 30 {
                let placed = PlacedTopping(ingredientId: ingredientId, positionX: posX, positionY: posY)
                uiState.placedToppings.append(placed)
                stateMachine.activeCookingSession?.addTopping(ingredientId: ingredientId, x: posX, y: posY)
                _ = stateMachine.activeCreativeSession?.addTopping(ingredientId: ingredientId, x: posX, y: posY)
            }
        }
        
        uiState.feedbackMessage = "Selected: \(ingredient.name)"
    }
    
    public func selectTool(_ toolId: String) {
        guard let tool = ToolRepository.shared.getToolById(toolId) else { return }
        uiState.selectedToolId = toolId
        uiState.activeTool = tool
        uiState.feedbackMessage = "Using tool: \(tool.name)"
    }
    
    public func advanceStep() {
        let nextIndex = uiState.currentStepIndex + 1
        if nextIndex < stepDefinitions.count {
            let step = stepDefinitions[nextIndex]
            let recipe = uiState.currentRecipe ?? RecipeRepository.shared.getAllRecipes().first!
            let available = getIngredientsForStep(mode: uiState.gameMode, stepId: step.id, recipe: recipe, creativeCategory: uiState.activeCreativeCategory)
            let tool = step.toolId.flatMap { ToolRepository.shared.getToolById($0) }
            
            _ = stateMachine.advanceCookingStep()
            
            uiState.currentStepIndex = nextIndex
            uiState.currentStepId = step.id
            uiState.currentStepTitle = step.title
            uiState.currentStepPrompt = step.prompt
            uiState.selectedIngredientId = nil
            uiState.selectedToolId = step.toolId
            uiState.availableIngredients = available
            uiState.activeTool = tool
            
            if nextIndex >= 1 { uiState.doughRollProgress = 1.0 }
            if nextIndex >= 6 && uiState.sauceCoverage == 0.0 { uiState.sauceCoverage = 0.85 }
            if nextIndex >= 7 && uiState.cheeseGrated == 0.0 { uiState.cheeseGrated = 0.90 }
            if nextIndex >= 9 { uiState.isBaked = true }
            
            uiState.feedbackMessage = "Advanced to: \(step.title)"
        } else {
            finishSession()
        }
    }
    
    public func skipStep() {
        _ = stateMachine.skipCurrentStep()
        let nextIndex = uiState.currentStepIndex + 1
        
        if nextIndex < stepDefinitions.count {
            let step = stepDefinitions[nextIndex]
            let recipe = uiState.currentRecipe ?? RecipeRepository.shared.getAllRecipes().first!
            let available = getIngredientsForStep(mode: uiState.gameMode, stepId: step.id, recipe: recipe, creativeCategory: uiState.activeCreativeCategory)
            let tool = step.toolId.flatMap { ToolRepository.shared.getToolById($0) }
            
            uiState.currentStepIndex = nextIndex
            uiState.currentStepId = step.id
            uiState.currentStepTitle = step.title
            uiState.currentStepPrompt = step.prompt
            uiState.selectedIngredientId = nil
            uiState.selectedToolId = step.toolId
            uiState.availableIngredients = available
            uiState.activeTool = tool
            uiState.skippedStepsCount += 1
            uiState.feedbackMessage = "Step skipped! Advanced to: \(step.title)"
        } else {
            finishSession()
        }
    }
    
    public func applyToddlerTap() {
        stateMachine.applyToddlerTap()
        let stepIdx = uiState.currentStepIndex
        if stepIdx == 0 {
            uiState.doughRollProgress = min(uiState.doughRollProgress + 0.25, 1.0)
        } else if stepIdx == 5 {
            uiState.sauceCoverage = min(uiState.sauceCoverage + 0.25, 1.0)
        } else if stepIdx == 6 {
            uiState.cheeseGrated = min(uiState.cheeseGrated + 0.25, 1.0)
        }
        uiState.feedbackMessage = "Toddler Tap! Progress +25%"
    }
    
    public func interactDough() {
        let inc: Float = (uiState.difficultyTier == 1) ? 0.35 : (uiState.difficultyTier == 2 ? 0.22 : 0.16)
        uiState.doughRollProgress = min(uiState.doughRollProgress + inc, 1.0)
        uiState.feedbackMessage = "Kneading dough!"
        SoundEffects.shared.playBoing()
    }
    
    public func interactRollDough() {
        let inc: Float = (uiState.difficultyTier == 1) ? 0.40 : (uiState.difficultyTier == 2 ? 0.25 : 0.18)
        uiState.doughRollProgress = min(uiState.doughRollProgress + inc, 1.0)
        uiState.feedbackMessage = "Rolling dough flat!"
        SoundEffects.shared.playRoll()
    }
    
    public func interactSwirlSauce() {
        let inc: Float = (uiState.difficultyTier == 1) ? 0.35 : (uiState.difficultyTier == 2 ? 0.22 : 0.16)
        uiState.sauceCoverage = min(uiState.sauceCoverage + inc, 1.0)
        uiState.feedbackMessage = "Swirling tomato sauce!"
        SoundEffects.shared.playSplat()
    }
    
    public func interactGrateCheese() {
        let inc: Float = (uiState.difficultyTier == 1) ? 0.40 : (uiState.difficultyTier == 2 ? 0.25 : 0.18)
        uiState.cheeseGrated = min(uiState.cheeseGrated + inc, 1.0)
        uiState.feedbackMessage = "Grating fresh cheese!"
        SoundEffects.shared.playGrate()
    }
    
    public func bakePizzaInOven() {
        uiState.isBaked = true
        uiState.ovenHeatProgress = 1.0
        uiState.feedbackMessage = "Pizza baked to golden perfection!"
        SoundEffects.shared.playDing()
    }
    
    public func addToppingAtPosition(_ ingredientId: String, normX: Float, normY: Float) {
        guard let ingredient = IngredientRepository.shared.getIngredientById(ingredientId) else { return }
        if uiState.placedToppings.count < 30 {
            uiState.placedToppings.append(PlacedTopping(ingredientId: ingredientId, positionX: normX, positionY: normY))
            _ = stateMachine.activeCookingSession?.addTopping(ingredientId: ingredientId, x: normX, y: normY)
            _ = stateMachine.activeCreativeSession?.addTopping(ingredientId: ingredientId, x: normX, y: normY)
            SoundEffects.shared.playPop()
        }
        uiState.selectedIngredientId = ingredientId
        uiState.feedbackMessage = "Placed: \(ingredient.name)"
    }
    
    public func clearToppings() {
        uiState.placedToppings.removeAll()
        uiState.feedbackMessage = "Cleared toppings!"
        SoundEffects.shared.playWhoosh()
    }

    public func takeBite() {
        uiState.bitesCount += 1
        stateMachine.activeCookingSession?.recordBite()
        uiState.feedbackMessage = "Yummy bite! (\(uiState.bitesCount) eaten)"
        SoundEffects.shared.playCrunch()
        if uiState.bitesCount >= 4 {
            finishSession()
        }
    }
    
    public func slicePizza() {
        if uiState.slicesCount == 0 {
            uiState.slicesCount = 6
        }
        stateMachine.activeCookingSession?.recordSlice()
        uiState.feedbackMessage = "Pizza sliced into 6 pieces!"
        SoundEffects.shared.playCrunch()
    }
    
    public func finishSession() {
        let score = stateMachine.finishSession()
        let tier = uiState.difficultyTier
        let fallback = calculateStarsFallback(uiState.skippedStepsCount)
        let calculated = score?.stars ?? fallback
        
        let stars: Int
        if uiState.skippedStepsCount > 0 {
            stars = fallback
        } else {
            switch tier {
            case 1: stars = 3
            case 2: stars = max(calculated, 2)
            default: stars = calculated
            }
        }
        
        uiState.isFinished = true
        uiState.scoreStars = stars
        uiState.feedbackMessage = "Congratulations! You earned \(stars) Stars!"
        SoundEffects.shared.playFanfare()
    }
    
    public func toggleAudio() {
        uiState.isAudioMuted.toggle()
    }
    
    private func calculateStarsFallback(_ skipped: Int) -> Int {
        switch skipped {
        case 0: return 3
        case 1: return 2
        default: return 1 // Zero 0-star penalty policy for kids
        }
    }
    
    private func getIngredientsForStep(mode: GameMode, stepId: String, recipe: Recipe, creativeCategory: String) -> [Ingredient] {
        if mode == .creativeMode {
            return getCreativeIngredientsForCategory(creativeCategory)
        }
        
        let all = IngredientRepository.shared.getAllIngredients()
        switch stepId {
        case "STEP-001", "STEP-002", "STEP-003", "STEP-005":
            return all.filter { $0.ingredientId == recipe.crustId }
        case "STEP-004", "STEP-006":
            return all.filter { $0.ingredientId == recipe.sauceId }
        case "STEP-007":
            return all.filter { $0.ingredientId == recipe.cheeseId }
        case "STEP-008":
            return all.filter { recipe.toppingIds.contains($0.ingredientId) }
        default:
            return []
        }
    }
    
    private func getCreativeIngredientsForCategory(_ category: String) -> [Ingredient] {
        let prefix: String
        switch category {
        case "VEGETABLE": prefix = "TOPPING_VEGGIE"
        case "MEAT": prefix = "TOPPING_MEAT"
        case "FRUIT": prefix = "TOPPING_FRUIT"
        case "SWEET": prefix = "TOPPING_SWEET"
        case "FANTASY": prefix = "TOPPING_FANTASY"
        default: prefix = "TOPPING_VEGGIE"
        }
        return IngredientRepository.shared.getAllIngredients().filter { $0.category == prefix }
    }
}
