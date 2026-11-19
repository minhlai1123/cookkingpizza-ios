import Foundation

public struct ScoreResult: Equatable {
    public let stars: Int
    public let feedbackMessage: String
    public let manualCompletionRate: Float
    public let sauceCoverage: Float
    public let toppingsCount: Int
    public let isOvenPassed: Bool

    public init(
        stars: Int,
        feedbackMessage: String,
        manualCompletionRate: Float,
        sauceCoverage: Float,
        toppingsCount: Int,
        isOvenPassed: Bool
    ) {
        self.stars = stars
        self.feedbackMessage = feedbackMessage
        self.manualCompletionRate = manualCompletionRate
        self.sauceCoverage = sauceCoverage
        self.toppingsCount = toppingsCount
        self.isOvenPassed = isOvenPassed
    }
}

public final class ScoringEngine {
    public static let shared = ScoringEngine()

    private init() {}

    public func calculateRecipeScore(session: CookingSession) -> ScoreResult {
        let totalSteps = session.totalSteps
        let manualSteps = session.manualStepsCompleted
        let skippedSteps = session.skippedStepsCount
        let manualRate: Float = totalSteps > 0 ? Float(manualSteps) / Float(totalSteps) : 1.0

        let sauceCoverage = session.sauceCoverage
        let toppingsCount = session.placedToppings.count

        // For no-bake recipes (R-03, R-17), baking is auto-passed
        let isOvenPassed = session.recipe.isNoBake ? true : session.isBaked
        let minToppingsRequired = session.recipe.completionRules.minToppings

        // 3 Stars criteria:
        // No skips (100% manual), sauce >= 80%, toppings >= minRequired, oven pass
        let gets3Stars = (skippedSteps == 0) &&
            (sauceCoverage >= 0.80) &&
            (toppingsCount >= minToppingsRequired) &&
            isOvenPassed

        // 2 Stars criteria:
        // At most 1 skip (or manualRate >= 0.80), sauce >= 60%, toppings >= min(3, minToppingsRequired)
        let gets2Stars = (skippedSteps <= 1 || manualRate >= 0.80) &&
            (sauceCoverage >= 0.60) &&
            (toppingsCount >= min(3, minToppingsRequired))

        let stars: Int
        if gets3Stars {
            stars = 3
        } else if gets2Stars {
            stars = 2
        } else {
            stars = 1 // Never 0 stars!
        }

        let feedback: String
        switch stars {
        case 3:
            feedback = "Master Chef! Perfect delicious pizza!"
        case 2:
            feedback = "Great Job! Looks yummy and smells wonderful!"
        default:
            feedback = "Super Fun! You made a wonderful pizza!"
        }

        return ScoreResult(
            stars = stars,
            feedbackMessage = feedback,
            manualCompletionRate = manualRate,
            sauceCoverage = sauceCoverage,
            toppingsCount = toppingsCount,
            isOvenPassed = isOvenPassed
        )
    }

    public func calculateCreativeScore(session: CreativeCookingSession) -> ScoreResult {
        return ScoreResult(
            stars = 3,
            feedbackMessage = "Incredible Creation! You are a brilliant pizza artist!",
            manualCompletionRate: 1.0,
            sauceCoverage: 1.0,
            toppingsCount: session.placedToppings.count,
            isOvenPassed: true
        )
    }
}
