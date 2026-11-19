import SwiftUI

public struct MainMenuView: View {
    public let onPlayClicked: () -> Void
    public let onGrownUpsClicked: () -> Void
    @State private var isPulsing: Bool = false
    @State private var isMuted: Bool = SoundEffects.shared.isMuted
    
    public init(
        onPlayClicked: @escaping () -> Void,
        onGrownUpsClicked: @escaping () -> Void
    ) {
        self.onPlayClicked = onPlayClicked
        self.onGrownUpsClicked = onGrownUpsClicked
    }
    
    public var body: some View {
        ResponsiveKitchenCanvas(ambientBackgroundColor: .warmKitchenWood) { width, height in
            ZStack {
                // 1. Italian Pizzeria Facade Canvas
                PizzeriaFacadeBackground()
                
                // 2. Top Controls
                VStack {
                    HStack {
                        // Sound Button
                        Button(action: {
                            SoundEffects.shared.isMuted.toggle()
                            isMuted = SoundEffects.shared.isMuted
                            if !isMuted { SoundEffects.shared.playPop() }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(isMuted ? Color.darkCharcoal : Color.gentleBlue)
                                    .frame(width: 48, height: 48)
                                    .overlay(Circle().stroke(Color.creamDoughWhite, lineWidth: 3))
                                    .shadow(radius: 4)
                                Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.creamDoughWhite)
                            }
                        }
                        
                        Spacer()
                        
                        // Grown-Ups Lock Button
                        Button(action: {
                            SoundEffects.shared.playPop()
                            onGrownUpsClicked()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.gentleBlue)
                                    .frame(width: 48, height: 48)
                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.creamDoughWhite, lineWidth: 3))
                                    .shadow(radius: 4)
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(.creamDoughWhite)
                            }
                        }
                    }
                    .padding(20)
                    
                    Spacer()
                }
                
                // 3. Main Title Banner
                VStack {
                    HStack(spacing: 8) {
                        Text("🍕 PIZZA COOKING WORLD 👨‍🍳")
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .foregroundColor(.creamDoughWhite)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(colors: [.warmTomatoRed, .goldenCrust, .warmTomatoRed], startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(24)
                    .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.creamDoughWhite, lineWidth: 4))
                    .shadow(radius: 8)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                
                // 4. Center Content: Pizza Preview on Left, 3D Play Button on Right
                HStack(spacing: 50) {
                    // Pizza Feature Badge
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 140, height: 140)
                                .overlay(Circle().stroke(Color.goldenCrust, lineWidth: 6))
                                .shadow(radius: 10)
                            CartoonPizzaThumbnail(recipeId: "R-02", size: 125)
                        }
                        
                        Text("20 MÓN CÔNG THỨC 🌟")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(.creamDoughWhite)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 4)
                            .background(Color.warmTomatoRed)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.creamDoughWhite, lineWidth: 2))
                    }
                    
                    // 3D Play Button
                    VStack(spacing: 10) {
                        Button(action: {
                            SoundEffects.shared.playPop()
                            onPlayClicked()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(colors: [Color(hex: 0x81C784), Color(hex: 0x2E7D32)], startPoint: .top, endPoint: .bottom)
                                    )
                                    .frame(width: 130, height: 130)
                                    .overlay(Circle().stroke(Color.creamDoughWhite, lineWidth: 6))
                                    .shadow(radius: 12)
                                    .scaleEffect(isPulsing ? 1.07 : 0.98)
                                
                                VStack(spacing: 2) {
                                    Image(systemName: "play.fill")
                                        .font(.system(size: 54, weight: .black))
                                        .foregroundColor(.creamDoughWhite)
                                    Text("CHƠI NGAY!")
                                        .font(.system(size: 13, weight: .black))
                                        .foregroundColor(.creamDoughWhite)
                                }
                            }
                        }
                        
                        Text("Chạm vào để bắt đầu làm pizza!")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.darkCharcoal)
                    }
                }
                .padding(.top, 60)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
                SoundEffects.shared.startBgm()
            }
        }
    }
}

/**
 * 2D Cartoon Italian Pizzeria Awning & Kitchen Wall
 */
private struct PizzeriaFacadeBackground: View {
    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            
            // Sky
            context.fill(Path(CGRect(x: 0, y: 0, width: w, height: h * 0.45)), with: .color(Color(hex: 0xFFFFE0B2)))
            
            // Striped Awning
            let awH = h * 0.22
            let stripeW = w / 16.0
            for i in 0..<16 {
                let col: Color = (i % 2 == 0) ? .warmTomatoRed : .creamDoughWhite
                context.fill(Path(CGRect(x: CGFloat(i) * stripeW, y: 0, width: stripeW + 1, height: awH)), with: .color(col))
                // Scallop bottom
                let scallop = Path { p in
                    p.addArc(center: CGPoint(x: CGFloat(i) * stripeW + stripeW / 2, y: awH), radius: stripeW / 2, startAngle: .zero, endAngle: .degrees(180), clockwise: false)
                }
                context.fill(scallop, with: .color(col))
            }
            
            // Tuscan Brick Wall
            context.fill(Path(CGRect(x: 0, y: awH + 16, width: w, height: h * 0.45)), with: .color(Color(hex: 0xFFFFF3E0)))
            
            // Oak Prep Counter
            context.fill(Path(CGRect(x: 0, y: h * 0.68, width: w, height: h * 0.32)), with: .color(.warmKitchenWood))
            context.fill(Path(CGRect(x: 0, y: h * 0.68 - 14, width: w, height: 18)), with: .color(.polishedOakWood))
        }
        .ignoresSafeArea()
    }
}
