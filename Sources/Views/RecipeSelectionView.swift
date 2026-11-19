import SwiftUI

public struct RecipeSelectionView: View {
    public let onRecipeSelected: (Recipe) -> Void
    public let onCreativeModeSelected: () -> Void
    public let onBackClicked: () -> Void
    
    @State private var selectedFilter: RecipeFilterCategory = .all
    @State private var isAudioMuted: Bool = SoundEffects.shared.isMuted
    @State private var pulseScale: CGFloat = 1.0
    
    private let allRecipes: [Recipe] = RecipeRepository.shared.getAllRecipes()
    
    public init(
        onRecipeSelected: @escaping (Recipe) -> Void,
        onCreativeModeSelected: @escaping () -> Void,
        onBackClicked: @escaping () -> Void
    ) {
        self.onRecipeSelected = onRecipeSelected
        self.onCreativeModeSelected = onCreativeModeSelected
        self.onBackClicked = onBackClicked
    }
    
    private var filteredRecipes: [Recipe] {
        switch selectedFilter {
        case .all:
            return allRecipes
        case .easy:
            return allRecipes.filter { RecipeMetadataRegistry.getInfo(for: $0.recipeId).difficultyTier == 1 }
        case .medium:
            return allRecipes.filter { RecipeMetadataRegistry.getInfo(for: $0.recipeId).difficultyTier == 2 }
        case .hard:
            return allRecipes.filter { RecipeMetadataRegistry.getInfo(for: $0.recipeId).difficultyTier == 3 }
        case .noBake:
            return allRecipes.filter { $0.isNoBake }
        }
    }
    
    public var body: some View {
        ResponsiveKitchenCanvas(ambientBackgroundColor: .warmKitchenWood) { width, height in
            ZStack {
                // 1. Italian Pizzeria Wall & Oak Counter Background
                PizzeriaMenuBackground()
                
                VStack(spacing: 8) {
                    // TOP BAR
                    HStack {
                        // Back Button
                        Button(action: {
                            SoundEffects.shared.playPop()
                            onBackClicked()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.warmTomatoRed)
                                    .frame(width: 46, height: 46)
                                    .overlay(Circle().stroke(Color.creamDoughWhite, lineWidth: 3))
                                    .shadow(radius: 4)
                                Image(systemName: "arrow.left")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.creamDoughWhite)
                            }
                        }
                        
                        Spacer()
                        
                        // Title Banner
                        HStack(spacing: 8) {
                            Text("🍕 CHỌN MÓN PIZZA CỦA BÉ — 20 MÓN ĐẶC SẮC 🍕")
                                .font(.system(size: 17, weight: .black))
                                .foregroundColor(.creamDoughWhite)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(
                            LinearGradient(colors: [.warmTomatoRed, .goldenCrust], startPoint: .leading, endPoint: .trailing)
                        )
                        .cornerRadius(20)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.creamDoughWhite, lineWidth: 3))
                        .shadow(radius: 6)
                        
                        Spacer()
                        
                        // Sound Toggle Button
                        Button(action: {
                            SoundEffects.shared.isMuted.toggle()
                            isAudioMuted = SoundEffects.shared.isMuted
                            if !isAudioMuted { SoundEffects.shared.playPop() }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(isAudioMuted ? Color.darkCharcoal : Color.gentleBlue)
                                    .frame(width: 46, height: 46)
                                    .overlay(Circle().stroke(Color.creamDoughWhite, lineWidth: 3))
                                    .shadow(radius: 4)
                                Image(systemName: isAudioMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.creamDoughWhite)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                    
                    // FILTER TABS
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(RecipeFilterCategory.allCases) { cat in
                                let isSelected = (selectedFilter == cat)
                                Button(action: {
                                    SoundEffects.shared.playPop()
                                    selectedFilter = cat
                                }) {
                                    HStack(spacing: 4) {
                                        Text(cat.icon)
                                        Text(cat.labelVi)
                                            .font(.system(size: 13, weight: isSelected ? .bold : .medium))
                                    }
                                    .foregroundColor(isSelected ? .creamDoughWhite : .darkCharcoal)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(isSelected ? Color.goldenCrust : Color.creamDoughWhite.opacity(0.9))
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(isSelected ? Color.crustBrownDark : Color.clear, lineWidth: 2)
                                    )
                                    .shadow(radius: isSelected ? 4 : 1)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // RECIPE CARDS HORIZONTAL SCROLLER
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(filteredRecipes, id: \.recipeId) { recipe in
                                RecipeCardView(recipe: recipe) {
                                    SoundEffects.shared.playFanfare()
                                    onRecipeSelected(recipe)
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 4)
                    }
                    
                    // BOTTOM BAR: CREATIVE MODE SHORTCUT
                    HStack {
                        Text("💡 Bé hãy chọn một chiếc pizza yêu thích để bắt đầu nấu nhé!")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.darkCharcoal)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.85))
                            .cornerRadius(12)
                        
                        Spacer()
                        
                        Button(action: {
                            SoundEffects.shared.playPop()
                            onCreativeModeSelected()
                        }) {
                            Text("🎨 CHẾ ĐỘ SÁNG TẠO TỰ DO")
                                .font(.system(size: 13, weight: .black))
                                .foregroundColor(.creamDoughWhite)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .background(
                                    LinearGradient(colors: [.magicViolet, .playfulCyan], startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(14)
                                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.creamDoughWhite, lineWidth: 2))
                                .shadow(radius: 4)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 6)
                }
            }
        }
    }
}

private struct RecipeCardView: View {
    let recipe: Recipe
    let onSelect: () -> Void
    
    var body: some View {
        let info = RecipeMetadataRegistry.getInfo(for: recipe.recipeId)
        
        VStack(spacing: 4) {
            // Top Row: Difficulty Pill & No-Bake tag
            HStack {
                Text(info.difficultyLabelVi)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(info.badgeColor)
                    .cornerRadius(8)
                
                Spacer()
                
                if recipe.isNoBake {
                    Text("🍓 KHÔNG NƯỚNG")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(hex: 0xE91E63))
                        .cornerRadius(6)
                } else {
                    Text(recipe.recipeId)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.darkCharcoal.opacity(0.5))
                }
            }
            
            // 2D Cartoon Pizza Thumbnail
            CartoonPizzaThumbnail(recipeId: recipe.recipeId, size: 90)
                .padding(.vertical, 2)
            
            // Name
            VStack(spacing: 1) {
                Text(info.nameVi)
                    .font(.system(size: 14, weight: .black))
                    .foregroundColor(.darkCharcoal)
                    .lineLimit(1)
                Text(info.nameEn)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.crustBrownDark.opacity(0.7))
                    .lineLimit(1)
            }
            
            // Description
            Text(info.descriptionVi)
                .font(.system(size: 10))
                .foregroundColor(.darkCharcoal.opacity(0.75))
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .frame(height: 26)
            
            // Key Toppings Preview
            HStack(spacing: 4) {
                ForEach(recipe.toppingIds.prefix(3), id: \.self) { tid in
                    CartoonToppingItem(ingredientId: tid, size: 22)
                }
            }
            
            // Cook Button
            Button(action: onSelect) {
                Text("NẤU NGAY! 🍕")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(.creamDoughWhite)
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
                    .background(
                        LinearGradient(colors: [Color(hex: 0x66BB6A), Color(hex: 0x388E3C)], startPoint: .top, endPoint: .bottom)
                    )
                    .cornerRadius(12)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.creamDoughWhite, lineWidth: 2))
                    .shadow(radius: 3)
            }
        }
        .padding(10)
        .frame(width: 220, height: 265)
        .background(Color.white)
        .cornerRadius(20)
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.crustBrownDark.opacity(0.2), lineWidth: 2))
        .shadow(radius: 6)
        .onTapGesture {
            onSelect()
        }
    }
}

/**
 * 2D Cartoon Pizzeria Wall & Counter Canvas for iOS
 */
private struct PizzeriaMenuBackground: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            // Upper Tuscan Wall
            context.fill(Path(CGRect(x: 0, y: 0, width: w, height: h * 0.52)), with: .color(Color(hex: 0xFFF8E1)))
            
            // Lower Wood Counter
            context.fill(Path(CGRect(x: 0, y: h * 0.52, width: w, height: h * 0.48)), with: .color(.warmKitchenWood))
            
            // Checkered Tablecloth Border
            let ckSize: CGFloat = 16
            let numCks = Int(w / ckSize) + 1
            for i in 0..<numCks {
                let col: Color = (i % 2 == 0) ? .warmTomatoRed : .creamDoughWhite
                context.fill(Path(CGRect(x: CGFloat(i) * ckSize, y: h * 0.52 - ckSize, width: ckSize, height: ckSize)), with: .color(col))
            }
            
            // Edge Trim
            context.fill(Path(CGRect(x: 0, y: h * 0.52, width: w, height: 12)), with: .color(.polishedOakWood))
        }
        .ignoresSafeArea()
    }
}
