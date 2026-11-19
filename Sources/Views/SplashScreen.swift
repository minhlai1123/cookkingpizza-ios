import SwiftUI

public struct SplashScreen: View {
    public let onSplashFinished: () -> Void
    @State private var bounceOffset: CGFloat = -200
    
    public init(onSplashFinished: @escaping () -> Void) {
        self.onSplashFinished = onSplashFinished
    }
    
    public var body: some View {
        ZStack {
            Color.warmKitchenWood
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.goldenCrust)
                        .frame(width: 96, height: 96)
                    Circle()
                        .fill(Color.creamDoughWhite)
                        .frame(width: 76, height: 76)
                }
                .offset(y: bounceOffset)
                
                Text("PIZZA COOKING WORLD")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.creamDoughWhite)
                
                Text("Loading Chef Kitchen...")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.warmTomatoRed)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                bounceOffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                onSplashFinished()
            }
        }
    }
}
