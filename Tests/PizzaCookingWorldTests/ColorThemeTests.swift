import XCTest
import SwiftUI
@testable import PizzaCookingWorld

final class ColorThemeTests: XCTestCase {
    
    func testHexColorInitialization() {
        let warmTomatoRed = Color.warmTomatoRed
        XCTAssertNotNil(warmTomatoRed)
        
        let goldenCrust = Color.goldenCrust
        XCTAssertNotNil(goldenCrust)
        
        let cheeseYellow = Color.cheeseYellow
        XCTAssertNotNil(cheeseYellow)
        
        let basilFreshGreen = Color.basilFreshGreen
        XCTAssertNotNil(basilFreshGreen)
        
        let warmKitchenWood = Color.warmKitchenWood
        XCTAssertNotNil(warmKitchenWood)
        
        let creamDoughWhite = Color.creamDoughWhite
        XCTAssertNotNil(creamDoughWhite)
        
        let gentleBlue = Color.gentleBlue
        XCTAssertNotNil(gentleBlue)
    }
}
