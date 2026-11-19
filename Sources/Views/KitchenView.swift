import SwiftUI

public struct KitchenView: View {
    @ObservedObject public var viewModel: KitchenViewModel
    public let onHomeClicked: () -> Void
    
    @State private var heatGauge: CGFloat = 0.1
    @State private var heatDirection: CGFloat = 0.03
    @State private var isBakingActive: Bool = false
    
    public init(viewModel: KitchenViewModel, onHomeClicked: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onHomeClicked = onHomeClicked
    }
    
    public var body: some View {
        let state = viewModel.uiState
        
        ResponsiveKitchenCanvas(ambientBackgroundColor: .warmKitchenWood) { width, height in
            ZStack {
                // 1. FULL KITCHEN ENVIRONMENT BACKGROUND
                KitchenEnvironmentBackground()
                
                // 2. MAIN WORKSPACE: Regions 3 (Left), 1 (Center), 2 (Right)
                HStack(spacing: 16) {
                    // REGION 3: Left Tool Station
                    toolStationRegion(state: state)
                        .frame(width: 170)
                    
                    // REGION 1: Center Pizza Worksurface (Strict 1:1 Aspect Ratio)
                    pizzaWorksurfaceRegion(state: state)
                        .frame(maxWidth: .infinity)
                    
                    // REGION 2: Right Shelf & Ingredient Tray
                    ingredientShelfRegion(state: state)
                        .frame(width: 250)
                }
                .padding(.top, 76)
                .padding(.bottom, 60)
                .padding(.horizontal, 24)
                
                // 3. TOP GUIDANCE SPEECH BUBBLE & TITLE
                VStack {
                    topGuidanceBar(state: state)
                        .padding(.top, 16)
                    Spacer()
                }
                
                // 4. TOP NAVIGATION CONTROLS (Home, Mute, Mode, Skip, Next)
                VStack {
                    topNavigationControls(state: state)
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                    Spacer()
                }
                
                // 5. BOTTOM PROGRESS BREADCRUMB
                VStack {
                    Spacer()
                    bottomProgressBreadcrumb(state: state)
                        .padding(.bottom, 10)
                }
                
                // 6. VICTORY CELEBRATION MODAL
                if state.isFinished {
                    victoryModal(state: state)
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // REGION 1: CENTER PIZZA WORKSURFACE (STRICT 1:1 CIRCLE)
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func pizzaWorksurfaceRegion(state: KitchenUiState) -> some View {
        ZStack {
            // Wooden Cutting Board / Prep Platter (Perfect Circle, never stretched)
            Circle()
                .fill(Color.polishedOakWood)
                .aspectRatio(1.0, contentMode: .fit)
                .overlay(Circle().stroke(Color.crustBrownDark, lineWidth: 8))
                .shadow(color: Color.black.opacity(0.3), radius: 14, x: 0, y: 8)
                .padding(8)
            
            // Pizza Disc Layer
            GeometryReader { geo in
                let size = min(geo.size.width, geo.size.height) * 0.82
                let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
                
                ZStack {
                    // Crust Base
                    Circle()
                        .fill(state.isBaked ? Color.goldenCrust : Color.creamDoughWhite)
                        .frame(width: size, height: size)
                        .overlay(Circle().stroke(state.isBaked ? Color.crustBrownDark : Color.goldenCrust, lineWidth: 6))
                        .shadow(radius: 6)
                        .position(center)
                    
                    if state.currentStepIndex == 0 && state.doughRollProgress < 0.8 {
                        // Dough Ball
                        Circle()
                            .fill(Color.creamDoughWhite)
                            .frame(width: size * 0.6, height: size * 0.6)
                            .overlay(Circle().stroke(Color.goldenCrust, lineWidth: 4))
                            .overlay(
                                Text("🥖\nTap to Knead!")
                                    .font(.system(size: 13, weight: .black))
                                    .foregroundColor(.crustBrownDark)
                                    .multilineTextAlignment(.center)
                            )
                            .position(center)
                            .onTapGesture { viewModel.interactDough() }
                    } else if state.currentStepIndex == 1 && state.doughRollProgress < 0.95 {
                        // Dough Rolling
                        Circle()
                            .fill(Color.creamDoughWhite)
                            .frame(width: size * (0.6 + CGFloat(state.doughRollProgress) * 0.35), height: size * (0.6 + CGFloat(state.doughRollProgress) * 0.35))
                            .overlay(Circle().stroke(Color.goldenCrust, lineWidth: 4))
                            .position(center)
                            .onTapGesture { viewModel.interactRollDough() }
                    } else {
                        // Sauce Layer
                        if state.sauceCoverage > 0.1 || state.currentStepIndex >= 6 {
                            Circle()
                                .fill(Color.warmTomatoRed)
                                .frame(width: size * 0.84, height: size * 0.84)
                                .position(center)
                                .onTapGesture {
                                    if state.currentStepIndex == 5 { viewModel.interactSwirlSauce() }
                                }
                        }
                        
                        // Cheese Layer
                        if state.cheeseGrated > 0.1 || state.currentStepIndex >= 7 {
                            Circle()
                                .fill(Color.cheeseYellow.opacity(0.9))
                                .frame(width: size * 0.74, height: size * 0.74)
                                .position(center)
                                .onTapGesture {
                                    if state.currentStepIndex == 6 { viewModel.interactGrateCheese() }
                                }
                        }
                        
                        // Placed Cartoon Toppings
                        ForEach(0..<state.placedToppings.count, id: \.self) { idx in
                            let topping = state.placedToppings[idx]
                            let offX = CGFloat((topping.positionX - 0.5)) * size * 0.65
                            let offY = CGFloat((topping.positionY - 0.5)) * size * 0.65
                            
                            CartoonToppingItem(ingredientId: topping.ingredientId, size: 36)
                                .position(x: center.x + offX, y: center.y + offY)
                        }
                        
                        // Level 1 Easy Mode Sparkling Guide Circles
                        if state.difficultyTier == 1 && state.placedToppings.count < 3 && state.currentStepIndex == 7 {
                            let guideOffsets: [CGPoint] = [
                                CGPoint(x: -35, y: -30),
                                CGPoint(x: 35, y: -25),
                                CGPoint(x: 0, y: 35)
                            ]
                            ForEach(0..<guideOffsets.count, id: \.self) { i in
                                Circle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(width: 34, height: 34)
                                    .overlay(Circle().stroke(Color.white.opacity(0.8), lineWidth: 2))
                                    .overlay(Text("✨").font(.system(size: 14)))
                                    .position(x: center.x + guideOffsets[i].x, y: center.y + guideOffsets[i].y)
                            }
                        }
                        
                        // Oven Baking Chamber overlay
                        if state.currentStepIndex == 8 {
                            ovenStageOverlay(state: state, size: size, center: center)
                        }
                        
                        // Slicing lines on Step 10
                        if state.currentStepIndex == 9 || state.slicesCount > 0 {
                            Path { path in
                                path.move(to: CGPoint(x: center.x, y: center.y - size / 2))
                                path.addLine(to: CGPoint(x: center.x, y: center.y + size / 2))
                                path.move(to: CGPoint(x: center.x - size / 2, y: center.y))
                                path.addLine(to: CGPoint(x: center.x + size / 2, y: center.y))
                            }
                            .stroke(Color.crustBrownDark, style: StrokeStyle(lineWidth: 3, dash: [8, 6]))
                        }
                        
                        // Bites on Step 10
                        if state.bitesCount > 0 {
                            Circle()
                                .fill(Color.polishedOakWood)
                                .frame(width: 44, height: 44)
                                .position(x: center.x + size * 0.32, y: center.y - size * 0.32)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            if state.currentStepIndex == 0 {
                viewModel.interactDough()
            } else if state.currentStepIndex == 1 {
                viewModel.interactRollDough()
            } else if state.currentStepIndex == 5 {
                viewModel.interactSwirlSauce()
            } else if state.currentStepIndex == 6 {
                viewModel.interactGrateCheese()
            } else if state.currentStepIndex == 9 {
                viewModel.takeBite()
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // OVEN STAGE OVERLAY (DIFFICULTY AWARE)
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func ovenStageOverlay(state: KitchenUiState, size: CGFloat, center: CGPoint) -> some View {
        if !state.isBaked && !isBakingActive {
            // Slide into Oven Button
            Button(action: {
                isBakingActive = true
                if state.difficultyTier < 3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        isBakingActive = false
                        viewModel.bakePizzaInOven()
                    }
                }
            }) {
                Text("🔥 START OVEN! 🔥")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color(hex: 0xE65100))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.white, lineWidth: 2))
                    .shadow(radius: 6)
            }
            .position(center)
        } else if isBakingActive {
            // Oven Door Simulation
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(hex: 0x263238))
                    .frame(width: size * 0.9, height: size * 0.9)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color(hex: 0xD84315), lineWidth: 6))
                
                VStack(spacing: 8) {
                    Text("🔥 BAKING PIZZA... 🔥")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(Color(hex: 0xFFFFB300))
                    
                    if state.difficultyTier == 3 {
                        // Hard mode heat needle
                        Text("Stop needle in the PERFECT GOLD zone! ⭐")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                        
                        // Heat Gauge Bar
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(LinearGradient(colors: [Color.blue, Color.yellow, Color.red], startPoint: .leading, endPoint: .trailing))
                                .frame(width: 160, height: 20)
                            
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: 8, height: 20)
                                .offset(x: 160 * heatGauge)
                        }
                        
                        Button(action: {
                            isBakingActive = false
                            viewModel.bakePizzaInOven()
                        }) {
                            Text("🔥 TAKE PIZZA OUT NOW! 🔥")
                                .font(.system(size: 11, weight: .black))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(Color.basilFreshGreen)
                                .cornerRadius(12)
                        }
                    } else {
                        Text("Sizzling & Melting!")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(hex: 0xFFFFCC80))
                    }
                }
            }
            .position(center)
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // REGION 2: RIGHT SHELF & INGREDIENT TRAY
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func ingredientShelfRegion(state: KitchenUiState) -> some View {
        VStack(spacing: 8) {
            Text(state.gameMode == .recipeMode ? "RECIPE SHELF" : "CREATIVE PANTRY")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.crustBrownDark)
                .padding(.top, 4)
            
            // Creative 5-Tab Bar
            if state.gameMode == .creativeMode {
                HStack(spacing: 4) {
                    categoryTabButton("🥕", "VEGETABLE", isSelected: state.activeCreativeCategory == "VEGETABLE")
                    categoryTabButton("🥩", "MEAT", isSelected: state.activeCreativeCategory == "MEAT")
                    categoryTabButton("🍓", "FRUIT", isSelected: state.activeCreativeCategory == "FRUIT")
                    categoryTabButton("🍬", "SWEET", isSelected: state.activeCreativeCategory == "SWEET")
                    categoryTabButton("⭐", "FANTASY", isSelected: state.activeCreativeCategory == "FANTASY")
                }
            }
            
            // Scrollable Ingredients with Cel-Shaded Cartoon Icons
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 8) {
                    ForEach(state.availableIngredients) { ingredient in
                        let isSelected = ingredient.ingredientId == state.selectedIngredientId
                        
                        HStack(spacing: 8) {
                            CartoonToppingItem(ingredientId: ingredient.ingredientId, size: 34)
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text(ingredient.name)
                                    .font(.system(size: 11, weight: .bold, design: .rounded))
                                    .foregroundColor(.darkCharcoal)
                                    .lineLimit(1)
                                Text(ingredient.ingredientId)
                                    .font(.system(size: 9, design: .rounded))
                                    .foregroundColor(.crustBrownDark.opacity(0.7))
                            }
                            
                            Spacer()
                            
                            if isSelected {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.goldenCrust)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(isSelected ? Color.starGoldGlory : Color.white)
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(isSelected ? Color.goldenCrust : Color.brushedSteelGray, lineWidth: isSelected ? 3 : 1.5)
                        )
                        .shadow(radius: isSelected ? 4 : 1)
                        .onTapGesture {
                            viewModel.selectIngredient(ingredient.ingredientId)
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(Color.warmMarbleCream)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.polishedOakWood, lineWidth: 3))
        .shadow(radius: 6)
    }
    
    @ViewBuilder
    private func categoryTabButton(_ emoji: String, _ category: String, isSelected: Bool) -> some View {
        Button(action: {
            viewModel.selectCreativeCategory(category)
        }) {
            Text(emoji)
                .font(.system(size: 16))
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.starGoldGlory : Color.brushedSteelGray)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(isSelected ? Color.goldenCrust : Color.clear, lineWidth: 2))
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // REGION 3: LEFT COUNTER & TOOL STATION
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func toolStationRegion(state: KitchenUiState) -> some View {
        VStack(spacing: 12) {
            Text("TOOL STATION")
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.crustBrownDark)
            
            if let tool = state.activeTool {
                let isSelected = tool.toolId == state.selectedToolId
                
                VStack(spacing: 6) {
                    Circle()
                        .fill(Color.gentleBlue)
                        .frame(width: 52, height: 52)
                        .overlay(Circle().stroke(Color.darkCharcoal, lineWidth: 2))
                        .overlay(Text("🛠️").font(.system(size: 24)))
                    
                    Text(tool.name)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.darkCharcoal)
                        .multilineTextAlignment(.center)
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.starGoldGlory : Color.white)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(isSelected ? Color.goldenCrust : Color.brushedSteelGray, lineWidth: 3))
                .onTapGesture {
                    viewModel.selectTool(tool.toolId)
                }
            } else {
                Text("Hand Placement\n(No Tool Needed)")
                    .font(.system(size: 10, design: .rounded))
                    .foregroundColor(.crustBrownDark.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 80)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(16)
            }
            
            Spacer()
            
            // Toddler Tap Quick Button (+25%)
            Button(action: {
                viewModel.applyToddlerTap()
            }) {
                Text("⚡ TAP +25%")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 42)
                    .background(Color.basilFreshGreen)
                    .cornerRadius(14)
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.darkCharcoal, lineWidth: 2))
                    .shadow(radius: 3)
            }
        }
        .padding(10)
        .background(Color.warmMarbleCream)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.polishedOakWood, lineWidth: 3))
        .shadow(radius: 6)
    }
    
    // ---------------------------------------------------------------------------------------------
    // REGION 4: TOP GUIDANCE SPEECH BUBBLE & DIFFICULTY BADGE
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func topGuidanceBar(state: KitchenUiState) -> some View {
        let info = state.currentRecipe.map { RecipeMetadataRegistry.getInfo(for: $0.recipeId) }
        let badgeStr: String = {
            switch state.difficultyTier {
            case 1: return "⭐ EASY"
            case 2: return "⭐⭐ MEDIUM"
            default: return "⭐⭐⭐ HARD"
            }
        }()
        let recipeTitle = info?.nameEn.uppercased() ?? "DELICIOUS PIZZA"
        
        HStack(spacing: 8) {
            Text("👨‍🍳").font(.system(size: 18))
            VStack(spacing: 1) {
                Text("[\(badgeStr)] \(recipeTitle)")
                    .font(.system(size: 12, weight: .black, design: .rounded))
                    .foregroundColor(.warmTomatoRed)
                Text("\(state.currentStepTitle): \(state.currentStepPrompt)")
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(.darkCharcoal)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .background(Color.warmMarbleCream)
        .cornerRadius(24)
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.goldenCrust, lineWidth: 3))
        .shadow(radius: 4)
    }
    
    // ---------------------------------------------------------------------------------------------
    // REGION 5: TOP NAVIGATION CONTROLS
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func topNavigationControls(state: KitchenUiState) -> some View {
        HStack {
            // Left Group
            HStack(spacing: 8) {
                Button(action: onHomeClicked) {
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.warmTomatoRed)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.darkCharcoal, lineWidth: 2))
                }
                
                Button(action: { viewModel.toggleAudio() }) {
                    Text(state.isAudioMuted ? "🔇" : "🔊")
                        .font(.system(size: 18))
                        .frame(width: 44, height: 44)
                        .background(state.isAudioMuted ? Color.softCoralAlert : Color.gentleBlue)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.darkCharcoal, lineWidth: 2))
                }
                
                Button(action: {
                    let next = state.gameMode == .recipeMode ? GameMode.creativeMode : GameMode.recipeMode
                    viewModel.switchMode(next)
                }) {
                    Text(state.gameMode == .recipeMode ? "📖 RECIPE" : "🎨 CREATIVE")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .frame(height: 44)
                        .background(state.gameMode == .recipeMode ? Color.goldenCrust : Color.magicViolet)
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.darkCharcoal, lineWidth: 2))
                }
            }
            
            Spacer()
            
            // Right Group: SKIP & NEXT
            HStack(spacing: 8) {
                Button(action: { viewModel.skipStep() }) {
                    Text(">> SKIP")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .frame(height: 44)
                        .background(Color.playfulCyan)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.darkCharcoal, lineWidth: 2))
                }
                
                Button(action: { viewModel.advanceStep() }) {
                    HStack(spacing: 4) {
                        Text("NEXT")
                            .font(.system(size: 12, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 44)
                    .background(Color.basilFreshGreen)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.darkCharcoal, lineWidth: 2))
                }
            }
        }
    }
    
    // ---------------------------------------------------------------------------------------------
    // REGION 6: BOTTOM PROGRESS BREADCRUMB
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func bottomProgressBreadcrumb(state: KitchenUiState) -> some View {
        HStack(spacing: 8) {
            ForEach(0..<state.totalSteps, id: \.self) { idx in
                if idx < state.currentStepIndex {
                    Circle()
                        .fill(Color.starGoldGlory)
                        .frame(width: 18, height: 18)
                        .overlay(Image(systemName: "star.fill").font(.system(size: 10)).foregroundColor(.darkCharcoal))
                } else if idx == state.currentStepIndex {
                    Circle()
                        .fill(Color.warmTomatoRed)
                        .frame(width: 24, height: 24)
                        .overlay(Circle().stroke(Color.starGoldGlory, lineWidth: 2))
                        .overlay(Text("\(idx + 1)").font(.system(size: 10, weight: .bold)).foregroundColor(.white))
                } else {
                    Circle()
                        .fill(Color.creamDoughWhite.opacity(0.5))
                        .frame(width: 14, height: 14)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 6)
        .background(Color.darkCharcoal.opacity(0.85))
        .cornerRadius(20)
    }
    
    // ---------------------------------------------------------------------------------------------
    // VICTORY CELEBRATION MODAL
    // ---------------------------------------------------------------------------------------------
    @ViewBuilder
    private func victoryModal(state: KitchenUiState) -> some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            
            VStack(spacing: 16) {
                Text("PIZZA COMPLETED!")
                    .font(.system(size: 20, weight: .heavy, design: .rounded))
                    .foregroundColor(.warmTomatoRed)
                
                Text(state.currentRecipe?.name ?? "Creative Pizza")
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(.darkCharcoal)
                
                HStack(spacing: 8) {
                    ForEach(1...3, id: \.self) { star in
                        let earned = star <= (state.scoreStars ?? 3)
                        Circle()
                            .fill(earned ? Color.starGoldGlory : Color.brushedSteelGray)
                            .frame(width: 50, height: 50)
                            .overlay(Circle().stroke(Color.darkCharcoal, lineWidth: 2))
                            .overlay(
                                Image(systemName: "star.fill")
                                    .font(.system(size: 28))
                                    .foregroundColor(earned ? .warmTomatoRed : .gray)
                            )
                    }
                }
                
                HStack(spacing: 12) {
                    Button(action: {
                        let recipe = state.currentRecipe ?? RecipeRepository.shared.getAllRecipes().first!
                        viewModel.initSession(recipe: recipe, mode: state.gameMode)
                    }) {
                        Text("COOK AGAIN")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(Color.basilFreshGreen)
                            .cornerRadius(16)
                    }
                    
                    Button(action: onHomeClicked) {
                        Text("RECIPE MENU")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 46)
                            .background(Color.warmTomatoRed)
                            .cornerRadius(16)
                    }
                }
            }
            .padding(24)
            .frame(width: 360)
            .background(Color.warmMarbleCream)
            .cornerRadius(28)
            .overlay(RoundedRectangle(cornerRadius: 28).stroke(Color.goldenCrust, lineWidth: 4))
            .shadow(radius: 16)
        }
    }
}

/**
 * 2D Cartoon Kitchen Wall with Sunny Window & Oak Table
 */
private struct KitchenEnvironmentBackground: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            // Mint Wall Tiles
            context.fill(Path(CGRect(x: 0, y: 0, width: w, height: h * 0.45)), with: .color(.pastelKitchenTile))
            
            // Sunny Window on Left
            let winRect = CGRect(x: w * 0.08, y: h * 0.08, width: 110, height: 80)
            context.fill(Path(roundedRect: winRect, cornerRadius: 10), with: .color(Color(hex: 0x81D4FA)))
            context.stroke(Path(roundedRect: winRect, cornerRadius: 10), with: .color(.white), lineWidth: 5)
            // Window pan cross
            context.stroke(Path { p in
                p.move(to: CGPoint(x: winRect.midX, y: winRect.minY))
                p.addLine(to: CGPoint(x: winRect.midX, y: winRect.maxY))
                p.move(to: CGPoint(x: winRect.minX, y: winRect.midY))
                p.addLine(to: CGPoint(x: winRect.maxX, y: winRect.midY))
            }, with: .color(.white), lineWidth: 3)
            
            // Little basil pot
            context.fill(Path(CGRect(x: winRect.minX + 10, y: winRect.maxY - 12, width: 22, height: 16)), with: .color(Color(hex: 0xBCAAA4)))
            context.fill(Path(ellipseIn: CGRect(x: winRect.minX + 8, y: winRect.maxY - 24, width: 26, height: 18)), with: .color(Color(hex: 0x4CAF50)))
            
            // Oak Prep Counter Base
            context.fill(Path(CGRect(x: 0, y: h * 0.45, width: w, height: h * 0.55)), with: .color(.warmKitchenWood))
            
            // Checkered Trim
            let ckSize: CGFloat = 16
            let numCks = Int(w / ckSize) + 1
            for i in 0..<numCks {
                let col: Color = (i % 2 == 0) ? .warmTomatoRed : .creamDoughWhite
                context.fill(Path(CGRect(x: CGFloat(i) * ckSize, y: h * 0.45 - ckSize, width: ckSize, height: ckSize)), with: .color(col))
            }
            
            // Counter Lip
            context.fill(Path(CGRect(x: 0, y: h * 0.45, width: w, height: 14)), with: .color(.polishedOakWood))
        }
        .ignoresSafeArea()
    }
}
