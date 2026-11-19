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
            
            let canvasWidth: CGFloat
            let canvasHeight: CGFloat
            
            if currentRatio > Constants.targetAspectRatio {
                // Ultrawide screen (e.g. 19.5:9): Fit by height
                canvasHeight = screenHeight
                canvasWidth = screenHeight * Constants.targetAspectRatio
            } else {
                // Squarer screen (e.g. 4:3 iPad): Fit by width
                canvasWidth = screenWidth
                canvasHeight = screenWidth / Constants.targetAspectRatio
            }
            
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
