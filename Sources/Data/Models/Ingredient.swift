import Foundation

public struct Ingredient: Codable, Equatable, Identifiable {
    public var id: String { ingredientId }
    public let ingredientId: String
    public let name: String
    public let category: String
    public let visualIdentifier: String
    public let applicableRecipes: [String]
    public let compatibleTools: [String]
    public let interactionType: String
    public let preparationRequirements: String

    public init(
        ingredientId: String,
        name: String,
        category: String,
        visualIdentifier: String,
        applicableRecipes: [String],
        compatibleTools: [String],
        interactionType: String,
        preparationRequirements: String
    ) {
        self.ingredientId = ingredientId
        self.name = name
        self.category = category
        self.visualIdentifier = visualIdentifier
        self.applicableRecipes = applicableRecipes
        self.compatibleTools = compatibleTools
        self.interactionType = interactionType
        self.preparationRequirements = preparationRequirements
    }
}
