import Foundation

public final class GameStateMachine {
    public private(set) var currentScreen: ScreenState
    public private(set) var currentMode: GameMode?
    public private(set) var activeCookingSession: CookingSession?
    public private(set) var activeCreativeSession: CreativeCookingSession?
    public private(set) var lastScoreResult: ScoreResult?

    private let allowedTransitions: [ScreenState: Set<ScreenState>] = [
        .splash: [.mainMenu],
        .mainMenu: [.recipeSelection, .creativeMode, .settingsParental],
        .recipeSelection: [.mainMenu, .recipePreparation],
        .recipePreparation: [.toppingAssembly, .recipeSelection, .mainMenu],
        .toppingAssembly: [.bakingOven, .cuttingServing, .recipePreparation, .mainMenu],
        .bakingOven: [.cuttingServing, .mainMenu],
        .cuttingServing: [.resultEvaluation, .mainMenu],
        .resultEvaluation: [.recipeSelection, .mainMenu, .recipePreparation, .creativeMode],
        .creativeMode: [.cuttingServing, .resultEvaluation, .mainMenu],
        .settingsParental: [.mainMenu]
    ]

    public init(initialScreen: ScreenState = .splash) {
        self.currentScreen = initialScreen
    }

    public func canTransition(to target: ScreenState) -> Bool {
        return allowedTransitions[currentScreen]?.contains(target) ?? false
    }

    @discardableResult
    public func transition(to target: ScreenState) -> Bool {
        if canTransition(to: target) {
            currentScreen = target
            return true
        }
        return false
    }

    @discardableResult
    public func startRecipe(_ recipe: Recipe) -> Bool {
        let session = CookingSession(recipe: recipe)
        session.startSession()
        activeCookingSession = session
        activeCreativeSession = nil
        currentMode = .recipeMode
        return transition(to: .recipePreparation)
    }

    @discardableResult
    public func startCreativeMode() -> Bool {
        activeCreativeSession = CreativeCookingSession()
        activeCookingSession = nullSafeSession()
        currentMode = .creativeMode
        return transition(to: .creativeMode)
    }

    private func nullSafeSession() -> CookingSession? {
        return nil
    }

    @discardableResult
    public func advanceCookingStep() -> Bool {
        guard let session = activeCookingSession else { return false }
        let moved = session.moveToNextStep()
        if moved {
            if let step = session.currentStep {
                switch step.stepType {
                case .doughPreparation, .crustRolling, .alternativeCrust:
                    transition(to: .recipePreparation)
                case .sauceSpreading, .cheeseGrating, .toppingDecoration:
                    transition(to: .toppingAssembly)
                case .ovenBaking:
                    transition(to: .bakingOven)
                case .slicingAndEating:
                    transition(to: .cuttingServing)
                default:
                    break
                }
            }
        } else {
            if currentScreen != .cuttingServing && currentScreen != .resultEvaluation {
                transition(to: .cuttingServing)
            }
        }
        return moved
    }

    @discardableResult
    public func skipCurrentStep() -> Bool {
        guard let session = activeCookingSession else { return false }
        let skipped = session.skipCurrentStep()
        if skipped {
            advanceCookingStep()
        } else if session.isFinished {
            transition(to: .cuttingServing)
        }
        return skipped
    }

    public func applyToddlerTap() {
        activeCookingSession?.applyToddlerTap()
    }

    public func finishSession() -> ScoreResult? {
        // Anti-double scoring guard: if session has already been finished, return cached result
        if let existing = lastScoreResult {
            return existing
        }

        guard let mode = currentMode else { return nil }
        switch mode {
        case .recipeMode:
            guard let session = activeCookingSession else { return nil }
            let result = ScoringEngine.shared.calculateRecipeScore(session: session)
            lastScoreResult = result
            transition(to: .resultEvaluation)
            return result
        case .creativeMode:
            guard let session = activeCreativeSession else { return nil }
            session.finishCreativePizza()
            let result = ScoringEngine.shared.calculateCreativeScore(session: session)
            lastScoreResult = result
            transition(to: .resultEvaluation)
            return result
        }
    }

    public func resetToMainMenu() {
        activeCookingSession = nil
        activeCreativeSession = nil
        currentMode = nil
        lastScoreResult = nil
        currentScreen = .mainMenu
    }
}
