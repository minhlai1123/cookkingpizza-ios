import SwiftUI
import Foundation

public struct ResponsiveKitchenCanvas<Content: View>: View {
    public let ambientBackgroundColor: Color
    public let content: (CGFloat, CGFloat) -> Content
    
    public init(
        ambientBackgroundColor: Color = .warmKitchenWood,
        @ViewBuilder content: @escaping (CGFloat, CGFloat) -> Content
    ) {
        self.ambientBackgroundColor = ambientBackgroundColor
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let currentRatio = screenHeight > 0 ? screenWidth / screenHeight : Constants.targetAspectRatio
            
            let isUltrawide = currentRatio > Constants.targetAspectRatio
            let canvasWidth: CGFloat = isUltrawide ? screenHeight * Constants.targetAspectRatio : screenWidth
            let canvasHeight: CGFloat = isUltrawide ? screenHeight : (Constants.targetAspectRatio > 0 ? screenWidth / Constants.targetAspectRatio : screenHeight)
            
            ZStack {
                ambientBackgroundColor
                    .ignoresSafeArea()
                
                content(canvasWidth, canvasHeight)
                    .frame(width: canvasWidth, height: canvasHeight)
                    .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
