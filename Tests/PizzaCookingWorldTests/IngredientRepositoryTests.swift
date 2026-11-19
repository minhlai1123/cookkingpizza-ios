import XCTest
@testable import PizzaCookingWorld

final class IngredientRepositoryTests: XCTestCase {

    func testRepository_containsOneHundredTwelveIngredients() {
        let all = IngredientRepository.shared.getAllIngredients()
        XCTAssertEqual(all.count, 112, "Master ingredient catalog must contain exactly 112 ingredients")
    }

    func testRepository_categoriesCountMatchesSpecification() {
        let crusts = IngredientRepository.shared.getCrusts()
        let sauces = IngredientRepository.shared.getSauces()
        let cheeses = IngredientRepository.shared.getCheeses()
        let toppings = IngredientRepository.shared.getToppings()

        XCTAssertEqual(crusts.count, 10, "Must contain 10 crusts")
        XCTAssertEqual(sauces.count, 10, "Must contain 10 sauces")
        XCTAssertEqual(cheeses.count, 6, "Must contain 6 cheeses")
        XCTAssertEqual(toppings.count, 86, "Must contain 86 toppings (>= 84 required by GDD)")
    }

    func testRepository_allIngredientIdsAndNamesAreUnique() {
        let all = IngredientRepository.shared.getAllIngredients()
        let ids = Set(all.map { $0.ingredientId })
        let names = Set(all.map { $0.name })
        let visualIds = Set(all.map { $0.visualIdentifier })

        XCTAssertEqual(ids.count, 112, "All 112 ingredient IDs must be unique")
        XCTAssertEqual(names.count, 112, "All 112 ingredient names must be unique")
        XCTAssertEqual(visualIds.count, 112, "All 112 visual identifiers must be unique")
    }

    func testRepository_ingredientLookupReturnsValidData() {
        let classicCrust = IngredientRepository.shared.getIngredientById("ING-001")
        XCTAssertNotNil(classicCrust)
        XCTAssertEqual(classicCrust?.name, "Classic Round Dough")
        XCTAssertEqual(classicCrust?.category, "CRUST")
        XCTAssertTrue(classicCrust?.applicableRecipes.contains("R-01") ?? false)

        let tomatoSauce = IngredientRepository.shared.getIngredientById("ING-011")
        XCTAssertNotNil(tomatoSauce)
        XCTAssertEqual(tomatoSauce?.name, "San Marzano Tomato Sauce")
        XCTAssertEqual(tomatoSauce?.category, "SAUCE")

        let mozzarella = IngredientRepository.shared.getIngredientById("ING-021")
        XCTAssertNotNil(mozzarella)
        XCTAssertEqual(mozzarella?.name, "Fresh Mozzarella Slices")
        XCTAssertEqual(mozzarella?.category, "CHEESE")
    }

    func testRepository_newCreativeToppingsAccessibleAndProperlyConfigured() {
        let roastedGarlic = IngredientRepository.shared.getIngredientById("ING-075")
        XCTAssertNotNil(roastedGarlic)
        XCTAssertEqual(roastedGarlic?.name, "Golden Roasted Garlic Cloves")
        XCTAssertEqual(roastedGarlic?.category, "TOPPING_VEGGIE")
        XCTAssertTrue(roastedGarlic?.applicableRecipes.contains("CREATIVE_MODE") ?? false)

        let octopus = IngredientRepository.shared.getIngredientById("ING-085")
        XCTAssertNotNil(octopus)
        XCTAssertEqual(octopus?.name, "Boiled Octopus Tentacles")
        XCTAssertEqual(octopus?.category, "TOPPING_MEAT")

        let mangoTurtles = IngredientRepository.shared.getIngredientById("ING-098")
        XCTAssertNotNil(mangoTurtles)
        XCTAssertEqual(mangoTurtles?.name, "Carved Mango Sea Turtles")
        XCTAssertEqual(mangoTurtles?.category, "TOPPING_FRUIT")

        let gummyWorms = IngredientRepository.shared.getIngredientById("ING-105")
        XCTAssertNotNil(gummyWorms)
        XCTAssertEqual(gummyWorms?.name, "Rainbow Gummy Worms")
        XCTAssertEqual(gummyWorms?.category, "TOPPING_SWEET")

        let beachFloaties = IngredientRepository.shared.getIngredientById("ING-115")
        XCTAssertNotNil(beachFloaties)
        XCTAssertEqual(beachFloaties?.name, "Gummy Beach Pool Floaties")
        XCTAssertEqual(beachFloaties?.category, "TOPPING_FANTASY")

        let sugarPearls = IngredientRepository.shared.getIngredientById("ING-122")
        XCTAssertNotNil(sugarPearls)
        XCTAssertEqual(sugarPearls?.name, "Starlight Glowing Sugar Pearls")
        XCTAssertEqual(sugarPearls?.category, "TOPPING_FANTASY")
    }

    func testRepository_fiveToppingSubcategoriesBreakdown() {
        let veggies = IngredientRepository.shared.getIngredientsByCategory("TOPPING_VEGGIE")
        let meats = IngredientRepository.shared.getIngredientsByCategory("TOPPING_MEAT")
        let fruits = IngredientRepository.shared.getIngredientsByCategory("TOPPING_FRUIT")
        let sweets = IngredientRepository.shared.getIngredientsByCategory("TOPPING_SWEET")
        let fantasy = IngredientRepository.shared.getIngredientsByCategory("TOPPING_FANTASY")

        XCTAssertEqual(veggies.count, 20, "Must contain 20 veggie toppings")
        XCTAssertEqual(meats.count, 19, "Must contain 19 meat/seafood toppings")
        XCTAssertEqual(fruits.count, 14, "Must contain 14 fresh fruit toppings")
        XCTAssertEqual(sweets.count, 25, "Must contain 25 sweet/candy toppings")
        XCTAssertEqual(fantasy.count, 8, "Must contain 8 fantasy/novelty toppings")

        let totalToppings = veggies.count + meats.count + fruits.count + sweets.count + fantasy.count
        XCTAssertEqual(totalToppings, 86)
    }

    func testRepository_ingredientsForRecipeR01() {
        let ingredients = IngredientRepository.shared.getIngredientsForRecipe("R-01")
        XCTAssertFalse(ingredients.isEmpty)
        let ids = ingredients.map { $0.ingredientId }
        XCTAssertTrue(ids.contains("ING-001"))
        XCTAssertTrue(ids.contains("ING-011"))
        XCTAssertTrue(ids.contains("ING-021"))
        XCTAssertTrue(ids.contains("ING-030"))
    }
}
