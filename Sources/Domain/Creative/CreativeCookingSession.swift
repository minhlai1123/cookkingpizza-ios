import Foundation

public final class CreativeCookingSession {
    public private(set) var selectedCrust: Ingredient?
    public private(set) var selectedSauce: Ingredient?
    public private(set) var selectedCheese: Ingredient?

    private var _placedToppings: [PlacedTopping] = []
    public var placedToppings: [PlacedTopping] { _placedToppings }

    public private(set) var isBaked: Bool = false
    public private(set) var slicesCount: Int = 0
    public private(set) var bitesCount: Int = 0
    public private(set) var isFinished: Bool = false

    public init() {}

    @discardableResult
    public func selectCrust(_ ingredientId: String) -> Bool {
        guard let ingredient = IngredientRepository.shared.getIngredientById(ingredientId) else { return false }
        guard ingredient.category == "CRUST" else { return false }
        selectedCrust = ingredient
        return true
    }

    @discardableResult
    public func selectSauce(_ ingredientId: String) -> Bool {
        guard let ingredient = IngredientRepository.shared.getIngredientById(ingredientId) else { return false }
        guard ingredient.category == "SAUCE" else { return false }
        selectedSauce = ingredient
        return true
    }

    @discardableResult
    public func selectCheese(_ ingredientId: String?) -> Bool {
        guard let id = ingredientId else {
            selectedCheese = nil
            return true
        }
        guard let ingredient = IngredientRepository.shared.getIngredientById(id) else { return false }
        guard ingredient.category == "CHEESE" else { return false }
        selectedCheese = ingredient
        return true
    }

    @discardableResult
    public func addTopping(ingredientId: String, x: Float, y: Float) -> Bool {
        guard let ingredient = IngredientRepository.shared.getIngredientById(ingredientId) else { return false }
        guard ingredient.category.hasPrefix("TOPPING") || ingredient.category == "CHEESE" else { return false }
        _placedToppings.append(PlacedTopping(ingredientId: ingredientId, positionX: x, positionY: y))
        return true
    }

    @discardableResult
    public func removeLastTopping() -> Bool {
        guard !_placedToppings.isEmpty else { return false }
        _placedToppings.removeLast()
        return true
    }

    public func clearToppings() {
        _placedToppings.removeAll()
    }

    public func bakePizza() {
        isBaked = true
    }

    public func slicePizza() {
        slicesCount += 1
    }

    public func bitePizza() {
        bitesCount += 1
    }

    @discardableResult
    public func finishCreativePizza() -> Bool {
        if selectedCrust == nil {
            selectedCrust = IngredientRepository.shared.getIngredientById("ING-001")
        }
        isFinished = true
        return true
    }
}
