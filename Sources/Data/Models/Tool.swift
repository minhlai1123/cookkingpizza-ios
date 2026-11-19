import Foundation

public struct Tool: Codable, Equatable, Identifiable {
    public var id: String { toolId }
    public let toolId: String
    public let name: String
    public let category: String
    public let actions: [String]
    public let applicableIngredients: [String]
    public let interactionType: String

    public init(
        toolId: String,
        name: String,
        category: String,
        actions: [String],
        applicableIngredients: [String],
        interactionType: String
    ) {
        self.toolId = toolId
        self.name = name
        self.category = category
        self.actions = actions
        self.applicableIngredients = applicableIngredients
        self.interactionType = interactionType
    }
}
