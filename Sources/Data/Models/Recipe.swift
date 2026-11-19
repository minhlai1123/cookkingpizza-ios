import Foundation

public struct CompletionRules: Codable, Equatable {
    public let minSauceCoverage: Float
    public let minToppings: Int
    public let requiresOven: BooleanLiteralType

    public init(minSauceCoverage: Float, minToppings: Int, requiresOven: Bool) {
        self.minSauceCoverage = minSauceCoverage
        self.minToppings = minToppings
        self.requiresOven = requiresOven
    }
}

public struct PresentationMetadata: Codable, Equatable {
    public let finishedDishLook: String
    public let backgroundTheme: String

    public init(finishedDishLook: String, backgroundTheme: String) {
        self.finishedDishLook = finishedDishLook
        self.backgroundTheme = backgroundTheme
    }
}

public struct Recipe: Codable, Equatable, Identifiable {
    public var id: String { recipeId }
    public let recipeId: String
    public let name: String
    public let description: String
    public let category: String
    public let difficulty: Int
    public let isNoBake: Bool
    public let crustId: String
    public let sauceId: String
    public let cheeseId: String?
    public let toppingIds: [String]
    public let toolIds: [String]
    public let specialMechanics: String
    public let completionRules: CompletionRules
    public let presentationMetadata: PresentationMetadata

    public init(
        recipeId: String,
        name: String,
        description: String,
        category: String,
        difficulty: Int,
        isNoBake: Bool,
        crustId: String,
        sauceId: String,
        cheeseId: String?,
        toppingIds: [String],
        toolIds: [String],
        specialMechanics: String,
        completionRules: CompletionRules,
        presentationMetadata: PresentationMetadata
    ) {
        self.recipeId = recipeId
        self.name = name
        self.description = description
        self.category = category
        self.difficulty = difficulty
        self.isNoBake = isNoBake
        self.crustId = crustId
        self.sauceId = sauceId
        self.cheeseId = cheeseId
        self.toppingIds = toppingIds
        self.toolIds = toolIds
        self.specialMechanics = specialMechanics
        self.completionRules = completionRules
        self.presentationMetadata = presentationMetadata
    }
}
