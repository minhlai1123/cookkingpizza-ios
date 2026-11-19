import Foundation

public enum StepType: String, Codable {
    case doughPreparation = "DOUGH_PREPARATION"
    case crustRolling = "CRUST_ROLLING"
    case ingredientSlicing = "INGREDIENT_SLICING"
    case sauceSimmering = "SAUCE_SIMMERING"
    case alternativeCrust = "ALTERNATIVE_CRUST"
    case sauceSpreading = "SAUCE_SPREADING"
    case cheeseGrating = "CHEESE_GRATING"
    case toppingDecoration = "TOPPING_DECORATION"
    case ovenBaking = "OVEN_BAKING"
    case slicingAndEating = "SLICING_AND_EATING"
}

public struct CookingStep: Codable, Equatable, Identifiable {
    public var id: String { stepId }
    public let stepId: String
    public let order: Int
    public let stepType: StepType
    public let title: String
    public let description: String
    public let requiredIngredients: [String]
    public let requiredTools: [String]
    public let expectedInteraction: String
    public let canSkip: Bool

    public init(
        stepId: String,
        order: Int,
        stepType: StepType,
        title: String,
        description: String,
        requiredIngredients: [String],
        requiredTools: [String],
        expectedInteraction: String,
        canSkip: Bool = true
    ) {
        self.stepId = stepId
        self.order = order
        self.stepType = stepType
        self.title = title
        self.description = description
        self.requiredIngredients = requiredIngredients
        self.requiredTools = requiredTools
        self.expectedInteraction = expectedInteraction
        self.canSkip = canSkip
    }
}
