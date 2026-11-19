import XCTest
@testable import PizzaCookingWorld

final class CreativeModeTests: XCTestCase {

    func testCreativeSession_canSelectAnyIngredientFreely() {
        let session = CreativeCookingSession()

        XCTAssertTrue(session.selectCrust("ING-002"))
        XCTAssertNotNil(session.selectedCrust)
        XCTAssertEqual(session.selectedCrust?.ingredientId, "ING-002")

        // Reject invalid crust category (e.g. sauce as crust)
        XCTAssertFalse(session.selectCrust("ING-011"))

        XCTAssertTrue(session.selectSauce("ING-013"))
        XCTAssertNotNil(session.selectedSauce)
        XCTAssertEqual(session.selectedSauce?.ingredientId, "ING-013")

        XCTAssertTrue(session.selectCheese("ING-021"))
        XCTAssertNotNil(session.selectedCheese)

        XCTAssertTrue(session.addTopping(ingredientId: "ING-030", x: 0.2, y: 0.3))
        XCTAssertTrue(session.addTopping(ingredientId: "ING-050", x: 0.5, y: 0.5))
        XCTAssertEqual(session.placedToppings.count, 2)

        XCTAssertTrue(session.removeLastTopping())
        XCTAssertEqual(session.placedToppings.count, 1)

        XCTAssertFalse(session.isBaked)
        session.bakePizza()
        XCTAssertTrue(session.isBaked)

        session.slicePizza()
        XCTAssertEqual(session.slicesCount, 1)

        session.bitePizza()
        XCTAssertEqual(session.bitesCount, 1)

        XCTAssertTrue(session.finishCreativePizza())
        XCTAssertTrue(session.isFinished)
    }

    func testCreativeSession_canUseAllNewExpandedToppingsFromAllFiveCategories() {
        let session = CreativeCookingSession()
        session.selectCrust("ING-001")
        session.selectSauce("ING-011")

        // Add one from each new category
        XCTAssertTrue(session.addTopping(ingredientId: "ING-075", x: 0.1, y: 0.1)) // Veggie: Roasted Garlic
        XCTAssertTrue(session.addTopping(ingredientId: "ING-085", x: 0.2, y: 0.2)) // Meat/Seafood: Octopus
        XCTAssertTrue(session.addTopping(ingredientId: "ING-098", x: 0.3, y: 0.3)) // Fruit: Mango Sea Turtles
        XCTAssertTrue(session.addTopping(ingredientId: "ING-105", x: 0.4, y: 0.4)) // Sweet: Gummy Worms
        XCTAssertTrue(session.addTopping(ingredientId: "ING-115", x: 0.5, y: 0.5)) // Fantasy: Beach Floaties
        XCTAssertTrue(session.addTopping(ingredientId: "ING-122", x: 0.6, y: 0.6)) // Fantasy: Starlight Pearls

        XCTAssertEqual(session.placedToppings.count, 6)
        XCTAssertTrue(session.finishCreativePizza())
        XCTAssertTrue(session.isFinished)
    }

    func testCreativeSession_defaultsToClassicCrustIfChildDidNotSelect() {
        let session = CreativeCookingSession()
        XCTAssertTrue(session.finishCreativePizza())
        XCTAssertNotNil(session.selectedCrust)
        XCTAssertEqual(session.selectedCrust?.ingredientId, "ING-001")
    }
}
