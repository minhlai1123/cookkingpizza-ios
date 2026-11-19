import Foundation

public enum ScreenState: String, Codable, CaseIterable {
    case splash = "M-01"
    case mainMenu = "M-02"
    case recipeSelection = "M-03"
    case recipePreparation = "M-04"
    case toppingAssembly = "M-05"
    case bakingOven = "M-06"
    case cuttingServing = "M-07"
    case resultEvaluation = "M-08"
    case creativeMode = "M-09"
    case settingsParental = "M-10"

    public var title: String {
        switch self {
        case .splash: return "Splash Screen"
        case .mainMenu: return "Main Menu"
        case .recipeSelection: return "Recipe Selection"
        case .recipePreparation: return "Recipe Preparation"
        case .toppingAssembly: return "Topping Assembly"
        case .bakingOven: return "Baking Oven"
        case .cuttingServing: return "Cutting & Serving"
        case .resultEvaluation: return "Result Evaluation"
        case .creativeMode: return "Creative Mode Freeform"
        case .settingsParental: return "Settings & Parental Gate"
        }
    }
}

public enum GameMode: String, Codable {
    case recipeMode = "RECIPE_MODE"
    case creativeMode = "CREATIVE_MODE"
}

public enum CookingState: String, Codable {
    case notStarted = "NOT_STARTED"
    case inProgress = "IN_PROGRESS"
    case stepCompleted = "STEP_COMPLETED"
    case readyForNextStep = "READY_FOR_NEXT_STEP"
    case completed = "COMPLETED"
    case skipped = "SKIPPED"
}

public enum InteractionType: String, Codable {
    case tap = "TAP"
    case swipe = "SWIPE"
    case dragAndDrop = "DRAG_AND_DROP"
    case hold = "HOLD"
    case toddlerTapFallback = "TODDLER_TAP_FALLBACK"
}
