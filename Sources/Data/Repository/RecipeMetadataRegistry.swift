import SwiftUI

public enum RecipeFilterCategory: String, CaseIterable, Identifiable {
    case all = "ALL"
    case easy = "EASY"
    case medium = "MEDIUM"
    case hard = "HARD"
    case noBake = "NO_BAKE"
    
    public var id: String { rawValue }
    
    public var label: String {
        switch self {
        case .all: return "All (20)"
        case .easy: return "Easy (6)"
        case .medium: return "Medium (9)"
        case .hard: return "Hard (5)"
        case .noBake: return "No-Bake (2)"
        }
    }
    
    public var labelVi: String { label }
    
    public var icon: String {
        switch self {
        case .all: return "🌟"
        case .easy: return "⭐"
        case .medium: return "⭐⭐"
        case .hard: return "⭐⭐⭐"
        case .noBake: return "🍓"
        }
    }
}

public struct RecipeLocalizedInfo {
    public let recipeId: String
    public let nameEn: String
    public let difficultyTier: Int // 1: Easy, 2: Medium, 3: Hard
    public let difficultyLabel: String
    public let badgeColor: Color
    public let descriptionEn: String
    
    public var nameVi: String { nameEn }
    public var difficultyLabelVi: String { difficultyLabel }
    public var descriptionVi: String { descriptionEn }
    
    public init(
        recipeId: String,
        nameEn: String,
        difficultyTier: Int,
        difficultyLabel: String,
        badgeColor: Color,
        descriptionEn: String
    ) {
        self.recipeId = recipeId
        self.nameEn = nameEn
        self.difficultyTier = difficultyTier
        self.difficultyLabel = difficultyLabel
        self.badgeColor = badgeColor
        self.descriptionEn = descriptionEn
    }
}

public struct RecipeMetadataRegistry {
    private static let registry: [String: RecipeLocalizedInfo] = [
        "R-01": RecipeLocalizedInfo(recipeId: "R-01", nameEn: "Classic Margherita", difficultyTier: 1, difficultyLabel: "⭐ EASY", badgeColor: Color(hex: 0x4CAF50), descriptionEn: "Fresh tomato sauce, melty mozzarella cheese, and fragrant basil."),
        "R-02": RecipeLocalizedInfo(recipeId: "R-02", nameEn: "Pepperoni Supreme", difficultyTier: 1, difficultyLabel: "⭐ EASY", badgeColor: Color(hex: 0x4CAF50), descriptionEn: "Crispy savory pepperoni slices, green bell peppers, and black olives."),
        "R-03": RecipeLocalizedInfo(recipeId: "R-03", nameEn: "Summer Watermelon", difficultyTier: 1, difficultyLabel: "⭐ EASY", badgeColor: Color(hex: 0x4CAF50), descriptionEn: "Juicy sweet watermelon crust, rainbow coconut sauce, no-bake treat!"),
        "R-04": RecipeLocalizedInfo(recipeId: "R-04", nameEn: "Sweet Candy & Marshmallow", difficultyTier: 1, difficultyLabel: "⭐ EASY", badgeColor: Color(hex: 0x4CAF50), descriptionEn: "Dark chocolate crust, chewy gummy bears, and fluffy marshmallows."),
        "R-05": RecipeLocalizedInfo(recipeId: "R-05", nameEn: "Four Cheese Formaggi", difficultyTier: 1, difficultyLabel: "⭐ EASY", badgeColor: Color(hex: 0x4CAF50), descriptionEn: "A rich, gooey blend of four cheeses with delicious cheesy pulls!"),
        "R-06": RecipeLocalizedInfo(recipeId: "R-06", nameEn: "Tropical Hawaiian Breeze", difficultyTier: 1, difficultyLabel: "⭐ EASY", badgeColor: Color(hex: 0x4CAF50), descriptionEn: "Savory ham slices paired with sweet and tangy golden pineapples."),
        "R-07": RecipeLocalizedInfo(recipeId: "R-07", nameEn: "Ahoy Pirate Treasure", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Search for chocolate gold coins on a mysterious high-seas pizza!"),
        "R-08": RecipeLocalizedInfo(recipeId: "R-08", nameEn: "Spooky Halloween Vampire", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Mystic black crust, crimson red sauce, and playful vampire bats."),
        "R-09": RecipeLocalizedInfo(recipeId: "R-09", nameEn: "Magical Rainbow Unicorn", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Pastel strawberry sauce, sparkling stars, and unicorn horn magic!"),
        "R-10": RecipeLocalizedInfo(recipeId: "R-10", nameEn: "Winter Wonderland Christmas", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Snowy white mozzarella, green Christmas trees, and red ornaments."),
        "R-11": RecipeLocalizedInfo(recipeId: "R-11", nameEn: "Gourmet BBQ Chicken", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Tender grilled chicken drizzled with rich, smoky barbecue sauce."),
        "R-12": RecipeLocalizedInfo(recipeId: "R-12", nameEn: "Japanese Takoyaki", difficultyTier: 3, difficultyLabel: "⭐⭐⭐ HARD", badgeColor: Color(hex: 0xE91E63), descriptionEn: "Japanese style with tender octopus chunks, savory mayo, and seaweed."),
        "R-13": RecipeLocalizedInfo(recipeId: "R-13", nameEn: "Fiesta Mexican Taco", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Seasoned ground beef, crispy corn tortilla chips, and zesty salsa."),
        "R-14": RecipeLocalizedInfo(recipeId: "R-14", nameEn: "Sunny Breakfast Egg & Bacon", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Golden sunny-side-up eggs and crispy savory bacon for breakfast."),
        "R-15": RecipeLocalizedInfo(recipeId: "R-15", nameEn: "Wild Forest Mushroom", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Fresh forest mushrooms infused with the aroma of truffle oil."),
        "R-16": RecipeLocalizedInfo(recipeId: "R-16", nameEn: "Circus Fun Carnival", difficultyTier: 3, difficultyLabel: "⭐⭐⭐ HARD", badgeColor: Color(hex: 0xE91E63), descriptionEn: "Sweet crunchy popcorn and rainbow candy confetti just like a circus!"),
        "R-17": RecipeLocalizedInfo(recipeId: "R-17", nameEn: "Berry Berry Fruit Tart", difficultyTier: 2, difficultyLabel: "⭐⭐ MEDIUM", badgeColor: Color(hex: 0xFF9800), descriptionEn: "Soft sweet tart crust, sweet cream, loaded with chilled strawberries!"),
        "R-18": RecipeLocalizedInfo(recipeId: "R-18", nameEn: "Volcano Spicy Pepper", difficultyTier: 3, difficultyLabel: "⭐⭐⭐ HARD", badgeColor: Color(hex: 0xE91E63), descriptionEn: "Smoking fiery peppers bursting with flavor for brave little chefs!"),
        "R-19": RecipeLocalizedInfo(recipeId: "R-19", nameEn: "Garden Veggie Bloom", difficultyTier: 3, difficultyLabel: "⭐⭐⭐ HARD", badgeColor: Color(hex: 0xE91E63), descriptionEn: "Arranged with zucchini ribbons, cherry tomatoes, and veggie petals."),
        "R-20": RecipeLocalizedInfo(recipeId: "R-20", nameEn: "Royal Galaxy Cosmic", difficultyTier: 3, difficultyLabel: "⭐⭐⭐ HARD", badgeColor: Color(hex: 0xE91E63), descriptionEn: "Deep cosmic purple crust sprinkled with golden stardust and glitter!")
    ]
    
    public static func getInfo(for recipeId: String) -> RecipeLocalizedInfo {
        return registry[recipeId] ?? RecipeLocalizedInfo(
            recipeId = recipeId,
            nameEn = "Delicious Pizza",
            difficultyTier = 1,
            difficultyLabel: "⭐ EASY",
            badgeColor: Color(hex: 0x4CAF50),
            descriptionEn = "A gourmet master pizza made by a talented little chef!"
        )
    }
}
