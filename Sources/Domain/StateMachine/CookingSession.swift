import Foundation

public struct PlacedTopping: Codable, Equatable {
    public let ingredientId: String
    public let positionX: Float
    public let positionY: Float
    public let timestampMs: Int64

    public init(ingredientId: String, positionX: Float, positionY: Float, timestampMs: Int64 = Int64(Date().timeIntervalSince1970 * 1000)) {
        self.ingredientId = ingredientId
        self.positionX = positionX
        self.positionY = positionY
        self.timestampMs = timestampMs
    }
}

public final class CookingSession {
    public let recipe: Recipe
    public let steps: [CookingStep]

    public private(set) var currentStepIndex: Int = 0
    public private(set) var cookingState: CookingState = .notStarted
    public private(set) var sauceCoverage: Float = 0.0
    private var _placedToppings: [PlacedTopping] = []
    public var placedToppings: [PlacedTopping] { _placedToppings }

    public private(set) var isBaked: Bool = false
    public private(set) var slicesCount: Int = 0
    public private(set) var bitesCount: Int = 0
    public private(set) var manualStepsCompleted: Int = 0
    public private(set) var skippedStepsCount: Int = 0
    public private(set) var toddlerTapCount: Int = 0
    public private(set) var currentStepProgress: Float = 0.0

    public init(recipe: Recipe, steps: [CookingStep]? = nil) {
        self.recipe = recipe
        self.steps = steps ?? CookingSession.defaultStepsForRecipe(recipe)
        if recipe.isNoBake {
            self.isBaked = true
        }
    }

    public var currentStep: CookingStep? {
        guard currentStepIndex >= 0 && currentStepIndex < steps.count else { return nil }
        return steps[currentStepIndex]
    }

    public var totalSteps: Int {
        return steps.count
    }

    public var isFinished: Bool {
        return cookingState == .completed || currentStepIndex >= steps.count
    }

    public func startSession() {
        if cookingState == .notStarted {
            currentStepIndex = 0
            cookingState = .inProgress
            currentStepProgress = 0.0
        }
    }

    public func updateProgress(_ progress: Float) {
        currentStepProgress = min(max(progress, 0.0), 1.0)
        if currentStepProgress >= 1.0 {
            completeCurrentStep(manual: true)
        }
    }

    public func applyToddlerTap() {
        toddlerTapCount += 1
        let newProgress = min(currentStepProgress + 0.25, 1.0)
        updateProgress(newProgress)
    }

    public func recordSauceCoverage(_ coverage: Float) {
        sauceCoverage = min(max(coverage, 0.0), 1.0)
    }

    public func addTopping(ingredientId: String, x: Float, y: Float) {
        _placedToppings.append(PlacedTopping(ingredientId: ingredientId, positionX: x, positionY: y))
    }

    public func completeBaking() {
        isBaked = true
    }

    public func recordSlice() {
        slicesCount += 1
    }

    public func recordBite() {
        bitesCount += 1
    }

    public func completeCurrentStep(manual: Bool) {
        if manual {
            manualStepsCompleted += 1
        } else {
            skippedStepsCount += 1
        }
        cookingState = .stepCompleted
    }

    @discardableResult
    public func skipCurrentStep() -> Bool {
        guard let step = currentStep, step.canSkip else { return false }
        completeCurrentStep(manual: false)
        return moveToNextStep()
    }

    @discardableResult
    public func moveToNextStep() -> Bool {
        if currentStepIndex + 1 < steps.count {
            currentStepIndex += 1
            currentStepProgress = 0.0
            cookingState = .inProgress
            return true
        } else {
            cookingState = .completed
            return false
        }
    }

    public static func defaultStepsForRecipe(_ recipe: Recipe) -> [CookingStep] {
        var list: [CookingStep] = []
        var order = 1

        list.append(
            CookingStep(
                stepId: "STEP-001",
                order: order,
                stepType: .doughPreparation,
                title: "Prepare Dough",
                description: "Knead and roll out the delicious dough.",
                requiredIngredients: [recipe.crustId],
                requiredTools: ["TOOL-001"],
                expectedInteraction: "SWIPE"
            )
        )
        order += 1

        list.append(
            CookingStep(
                stepId: "STEP-006",
                order: order,
                stepType: .sauceSpreading,
                title: "Spread Sauce",
                description: "Ladle sauce in smooth spirals across the crust.",
                requiredIngredients: [recipe.sauceId],
                requiredTools: ["TOOL-006"],
                expectedInteraction: "SWIPE"
            )
        )
        order += 1

        if let cheeseId = recipe.cheeseId {
            list.append(
                CookingStep(
                    stepId: "STEP-007",
                    order: order,
                    stepType: .cheeseGrating,
                    title: "Grate Cheese",
                    description: "Grate flavorful cheese all over the sauce.",
                    requiredIngredients: [cheeseId],
                    requiredTools: ["TOOL-005"],
                    expectedInteraction: "SWIPE"
                )
            )
            order += 1
        }

        list.append(
            CookingStep(
                stepId: "STEP-008",
                order: order,
                stepType: .toppingDecoration,
                title: "Place Toppings",
                description: "Decorate your pizza with vibrant toppings.",
                requiredIngredients: recipe.toppingIds,
                requiredTools: [],
                expectedInteraction: "DRAG_AND_DROP"
            )
        )
        order += 1

        if !recipe.isNoBake {
            list.append(
                CookingStep(
                    stepId: "STEP-009",
                    order: order,
                    stepType: .ovenBaking,
                    title: "Bake in Oven",
                    description: "Slide into the hot oven and watch it bake golden.",
                    requiredIngredients: [],
                    requiredTools: ["TOOL-007"],
                    expectedInteraction: "SWIPE"
                )
            )
            order += 1
        }

        list.append(
            CookingStep(
                stepId: "STEP-010",
                order: order,
                stepType: .slicingAndEating,
                title: "Slice & Enjoy",
                description: "Slice into delicious pieces and enjoy every bite!",
                requiredIngredients: [],
                requiredTools: ["TOOL-008"],
                expectedInteraction: "SWIPE"
            )
        )

        return list
    }
}
