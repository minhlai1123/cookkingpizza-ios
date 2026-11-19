import SwiftUI

public enum AppScreenState {
    case splash
    case mainMenu
    case recipeSelection
    case kitchen
}

public struct RootContentView: View {
    @State private var currentScreen: AppScreenState = .splash
    @StateObject private var kitchenViewModel = KitchenViewModel()
    
    public init() {}
    
    public var body: some View {
        ZStack {
            switch currentScreen {
            case .splash:
                SplashScreen {
                    withAnimation {
                        currentScreen = .mainMenu
                    }
                }
            case .mainMenu:
                MainMenuView(
                    onPlayClicked: {
                        withAnimation {
                            currentScreen = .recipeSelection
                        }
                    },
                    onGrownUpsClicked: {
                        // Parental Gate Modal
                    }
                )
            case .recipeSelection:
                RecipeSelectionView(
                    onRecipeSelected: { selectedRecipe in
                        kitchenViewModel.initSession(recipe: selectedRecipe, mode: .recipeMode)
                        withAnimation {
                            currentScreen = .kitchen
                        }
                    },
                    onCreativeModeSelected: {
                        let defaultRecipe = RecipeRepository.shared.getAllRecipes().first!
                        kitchenViewModel.initSession(recipe: defaultRecipe, mode: .creativeMode)
                        withAnimation {
                            currentScreen = .kitchen
                        }
                    },
                    onBackClicked: {
                        withAnimation {
                            currentScreen = .mainMenu
                        }
                    }
                )
            case .kitchen:
                KitchenView(
                    viewModel: kitchenViewModel,
                    onHomeClicked: {
                        withAnimation {
                            currentScreen = .recipeSelection
                        }
                    }
                )
            }
        }
    }
}
