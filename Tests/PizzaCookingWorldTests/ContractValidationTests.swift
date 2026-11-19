import XCTest
@testable import PizzaCookingWorld

final class ContractValidationTests: XCTestCase {
    
    func testTotalRecipesCount() {
        XCTAssertEqual(Constants.totalRecipes, 20)
    }
    
    func testTargetAspectRatio() {
        XCTAssertEqual(Constants.targetAspectRatio, 16.0 / 9.0, accuracy: 0.001)
    }
    
    func testRecipeIdPattern() {
        let recipeIds = (1...20).map { String(format: "R-%02d", $0) }
        XCTAssertEqual(recipeIds.count, 20)
        XCTAssertEqual(recipeIds.first, "R-01")
        XCTAssertEqual(recipeIds.last, "R-20")
        
        let regex = try! NSRegularExpression(pattern: "^R-\\d{2}$")
        for id in recipeIds {
            let range = NSRange(location: 0, length: id.utf16.count)
            XCTAssertNotNil(regex.firstMatch(in: id, options: [], range: range))
        }
    }
    
    func testStarScoringLogic() {
        func evaluateStars(
            isColdRecipe: Bool,
            manualStepRatio: Double,
            sauceCoverage: Double,
            toppingCount: Int,
            ovenPerfectBake: Bool
        ) -> Int {
            let ovenPassed = isColdRecipe ? true : ovenPerfectBake
            if manualStepRatio >= 1.0 && sauceCoverage >= 0.80 && toppingCount >= 5 && ovenPassed {
                return 3
            } else if manualStepRatio >= 0.80 && sauceCoverage >= 0.60 && toppingCount >= 3 {
                return 2
            } else {
                return 1
            }
        }
        
        XCTAssertEqual(evaluateStars(isColdRecipe: false, manualStepRatio: 1.0, sauceCoverage: 0.85, toppingCount: 6, ovenPerfectBake: true), 3)
        XCTAssertEqual(evaluateStars(isColdRecipe: true, manualStepRatio: 1.0, sauceCoverage: 0.82, toppingCount: 5, ovenPerfectBake: false), 3)
        XCTAssertEqual(evaluateStars(isColdRecipe: false, manualStepRatio: 0.85, sauceCoverage: 0.65, toppingCount: 3, ovenPerfectBake: false), 2)
        XCTAssertEqual(evaluateStars(isColdRecipe: false, manualStepRatio: 0.50, sauceCoverage: 0.40, toppingCount: 1, ovenPerfectBake: false), 1)
    }
}
