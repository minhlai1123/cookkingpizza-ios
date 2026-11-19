import Foundation

public struct RecipeValidationResult: Equatable {
    public let isValid: Bool
    public let errors: [String]

    public init(isValid: Bool, errors: [String] = []) {
        self.isValid = isValid
        self.errors = errors
    }
}

public final class RecipeValidator {
    public static let shared = RecipeValidator()

    private let recipeIdRegex = try! NSRegularExpression(pattern: "^R-(0[1-9]|1[0-9]|20)$")

    private init() {}

    public func validateRecipe(_ recipe: Recipe) -> RecipeValidationResult {
        var errors: [String] = []

        let range = NSRange(location: 0, length: recipe.recipeId.utf16.count)
        if recipeIdRegex.firstMatch(in: recipe.recipeId, options: [], range: range) == nil {
            errors.append("Invalid recipeId format: \(recipe.recipeId)")
        }

        if recipe.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Recipe name cannot be blank for \(recipe.recipeId)")
        }

        if recipe.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errors.append("Recipe description cannot be blank for \(recipe.recipeId)")
        }

        if recipe.difficulty < 1 || recipe.difficulty > 5 {
            errors.append("Recipe difficulty must be between 1 and 5 for \(recipe.recipeId)")
        }

        // Validate crust
        if let crust = IngredientRepository.shared.getIngredientById(recipe.crustId) {
            if crust.category != "CRUST" {
                errors.append("Ingredient \(recipe.crustId) is not a CRUST (found \(crust.category))")
            }
        } else {
            errors.append("Crust \(recipe.crustId) does not exist in IngredientRepository")
        }

        // Validate sauce
        if let sauce = IngredientRepository.shared.getIngredientById(recipe.sauceId) {
            if sauce.category != "SAUCE" {
                errors.append("Ingredient \(recipe.sauceId) is not a SAUCE (found \(sauce.category))")
            }
        } else {
            errors.append("Sauce \(recipe.sauceId) does not exist in IngredientRepository")
        }

        // Validate cheese (optional)
        if let cheeseId = recipe.cheeseId {
            if let cheese = IngredientRepository.shared.getIngredientById(cheeseId) {
                if cheese.category != "CHEESE" {
                    errors.append("Ingredient \(cheeseId) is not a CHEESE (found \(cheese.category))")
                }
            } else {
                errors.append("Cheese \(cheeseId) does not exist in IngredientRepository")
            }
        }

        // Validate toppings
        if recipe.toppingIds.isEmpty {
            errors.append("Recipe \(recipe.recipeId) must have at least one topping")
        }
        for toppingId in recipe.toppingIds {
            if let topping = IngredientRepository.shared.getIngredientById(toppingId) {
                if !topping.category.hasPrefix("TOPPING") && topping.category != "CHEESE" {
                    errors.append("Ingredient \(toppingId) is not a valid topping or cheese garnish (found \(topping.category))")
                }
            } else {
                errors.append("Topping \(toppingId) does not exist in IngredientRepository")
            }
        }

        // Validate tools
        if recipe.toolIds.isEmpty {
            errors.append("Recipe \(recipe.recipeId) must require at least one tool")
        }
        for toolId in recipe.toolIds {
            if !ToolRepository.shared.hasTool(toolId) {
                errors.append("Tool \(toolId) does not exist in ToolRepository")
            }
        }

        // Validate completion rules
        if recipe.completionRules.minSauceCoverage < 0.0 || recipe.completionRules.minSauceCoverage > 1.0 {
            errors.append("minSauceCoverage must be between 0.0 and 1.0 (found \(recipe.completionRules.minSauceCoverage))")
        }
        if recipe.completionRules.minToppings < 1 {
            errors.append("minToppings must be at least 1 (found \(recipe.completionRules.minToppings))")
        }

        // No-bake consistency
        if recipe.isNoBake && recipe.completionRules.requiresOven {
            errors.append("No-bake recipe \(recipe.recipeId) cannot have requiresOven = true")
        }

        return RecipeValidationResult(isValid: errors.isEmpty, errors: errors)
    }

    public func validateAllRecipes(_ recipes: [Recipe]) -> RecipeValidationResult {
        var allErrors: [String] = []

        if recipes.count != 20 {
            allErrors.append("Expected exactly 20 recipes, but found \(recipes.count)")
        }

        let uniqueIds = Set(recipes.map { $0.recipeId })
        if uniqueIds.count != recipes.count {
            allErrors.append("Duplicate recipe IDs found")
        }

        for recipe in recipes {
            let result = validateRecipe(recipe)
            if !result.isValid {
                allErrors.append(contentsOf: result.errors)
            }
        }

        return RecipeValidationResult(isValid: allErrors.isEmpty, errors: allErrors)
    }
}
