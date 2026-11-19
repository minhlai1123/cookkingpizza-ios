import Foundation

public struct KitchenUiState: Equatable {
    public var gameMode: GameMode = .recipeMode
    public var currentRecipe: Recipe? = nil
    public var currentStepIndex: Int = 0
    public var totalSteps: Int = 10
    public var currentStepId: String = "STEP-001"
    public var currentStepTitle: String = "Dough Kneading"
    public var currentStepPrompt: String = "Tap and punch the dough ball!"
    public var selectedIngredientId: String? = nil
    public var selectedToolId: String? = nil
    public var activeCreativeCategory: String = "VEGETABLE"
    public var availableIngredients: [Ingredient] = []
    public var activeTool: Tool? = nil
    public var placedToppings: [PlacedTopping] = []
    public var sauceCoverage: Float = 0.0
    public var cheeseGrated: Float = 0.0
    public var doughRollProgress: Float = 0.0
    public var isBaked: Bool = false
    public var slicesCount: Int = 0
    public var bitesCount: Int = 0
    public var isAudioMuted: Bool = false
    public var skippedStepsCount: Int = 0
    public var difficultyTier: Int = 1
    public var ovenHeatProgress: Float = 0.0
    public var isFinished: Bool = false
    public var scoreStars: Int? = nil
    public var feedbackMessage: String = "Welcome to Pizza Kitchen!"
    
    public init() {}
}
