import SwiftUI

/**
 * 2D Cartoon Food & Kitchen Art Renderer for iOS SwiftUI.
 * Cel-shaded cartoon graphics with bold outlines matching the Android implementation.
 */
public struct CartoonToppingItem: View {
    public let ingredientId: String
    public var size: CGFloat = 40

    public init(ingredientId: String, size: CGFloat = 40) {
        self.ingredientId = ingredientId
        self.size = size
    }

    public var body: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let center = CGPoint(x: w / 2, y: h / 2)

            if ingredientId.hasPrefix("ING-01") {
                // Sauce Bowl / Jar
                let sauceColor: Color = {
                    switch ingredientId {
                    case "ING-012": return Color(hex: 0xFFF9C4)
                    case "ING-013": return Color(hex: 0xFFFF80AB)
                    case "ING-014": return Color(hex: 0xFF5D4037)
                    case "ING-015": return Color(hex: 0xFFFF7043)
                    case "ING-016": return Color(hex: 0xFF8D6E63)
                    case "ING-017": return Color(hex: 0xFF66BB6A)
                    default: return Color(hex: 0xFFD32F2F)
                    }
                }()
                let bowlPath = Path { p in
                    p.addArc(center: CGPoint(x: w * 0.5, y: h * 0.45), radius: w * 0.35, startAngle: .zero, endAngle: .degrees(180), clockwise: false)
                    p.closeSubpath()
                }
                context.fill(bowlPath, with: .color(Color(hex: 0xFFECEFF1)))
                context.stroke(bowlPath, with: .color(Color(hex: 0xFFB0BEC5)), lineWidth: w * 0.05)
                context.fill(Path(ellipseIn: CGRect(x: w * 0.2, y: h * 0.35, width: w * 0.6, height: h * 0.25)), with: .color(sauceColor))

            } else if ingredientId.hasPrefix("ING-02") {
                // Cheese Wedge
                let cheeseColor: Color = (ingredientId == "ING-022") ? Color(hex: 0xFFFFB300) : Color(hex: 0xFFFFF176)
                let wedgePath = Path { p in
                    p.move(to: CGPoint(x: w * 0.15, y: h * 0.75))
                    p.addLine(to: CGPoint(x: w * 0.85, y: h * 0.75))
                    p.addLine(to: CGPoint(x: w * 0.50, y: h * 0.20))
                    p.closeSubpath()
                }
                context.fill(wedgePath, with: .color(cheeseColor))
                context.stroke(wedgePath, with: .color(Color(hex: 0xFFF57F17)), lineWidth: w * 0.06)
                // Cheese holes
                context.fill(Path(ellipseIn: CGRect(x: w * 0.38, y: h * 0.52, width: w * 0.14, height: w * 0.14)), with: .color(Color(hex: 0xFFFBC02D)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.58, y: h * 0.60, width: w * 0.10, height: w * 0.10)), with: .color(Color(hex: 0xFFFBC02D)))

            } else if ingredientId.contains("040") || ingredientId.contains("043") {
                // Pepperoni
                context.fill(Path(ellipseIn: CGRect(x: w * 0.04, y: h * 0.04, width: w * 0.92, height: h * 0.92)), with: .color(Color(hex: 0xFFB71C1C)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.08, y: h * 0.08, width: w * 0.84, height: h * 0.84)), with: .color(Color(hex: 0xFFD32F2F)))
                // Fat specks
                context.fill(Path(ellipseIn: CGRect(x: w * 0.32, y: h * 0.32, width: w * 0.14, height: w * 0.14)), with: .color(Color(hex: 0xFFFF8A80)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.60, y: h * 0.40, width: w * 0.11, height: w * 0.11)), with: .color(Color(hex: 0xFFFF8A80)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.42, y: h * 0.62, width: w * 0.12, height: w * 0.12)), with: .color(Color(hex: 0xFFFF8A80)))

            } else if ingredientId.contains("034") || ingredientId.contains("035") {
                // Fresh Basil Leaf
                let leafPath = Path { p in
                    p.move(to: CGPoint(x: w * 0.5, y: h * 0.1))
                    p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.9), control: CGPoint(x: w * 0.95, y: h * 0.5))
                    p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.1), control: CGPoint(x: w * 0.05, y: h * 0.5))
                    p.closeSubpath()
                }
                context.fill(leafPath, with: .color(Color(hex: 0xFF43A047)))
                context.stroke(leafPath, with: .color(Color(hex: 0xFF1B5E20)), lineWidth: w * 0.06)

            } else if ingredientId.contains("031") {
                // Button Mushroom
                let stemRect = CGRect(x: w * 0.38, y: h * 0.45, width: w * 0.24, height: h * 0.45)
                context.fill(Path(roundedRect: stemRect, cornerRadius: 4), with: .color(Color(hex: 0xFFE0E0E0)))
                let capPath = Path { p in
                    p.move(to: CGPoint(x: w * 0.15, y: h * 0.55))
                    p.addQuadCurve(to: CGPoint(x: w * 0.85, y: h * 0.55), control: CGPoint(x: w * 0.5, y: h * 0.10))
                    p.closeSubpath()
                }
                context.fill(capPath, with: .color(Color(hex: 0xFFF5F5F5)))
                context.stroke(capPath, with: .color(Color(hex: 0xFF6D4C41)), lineWidth: w * 0.06)

            } else if ingredientId.contains("033") {
                // Black Olive Ring
                context.fill(Path(ellipseIn: CGRect(x: w * 0.06, y: h * 0.06, width: w * 0.88, height: h * 0.88)), with: .color(Color(hex: 0xFF212121)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.30, y: h * 0.30, width: w * 0.40, height: h * 0.40)), with: .color(Color(hex: 0xFFD7CCC8)))

            } else if ingredientId.contains("030") || ingredientId.contains("036") || ingredientId.contains("032") {
                // Bell Pepper Ring
                let pCol: Color = ingredientId.contains("030") ? Color(hex: 0xFF2E7D32) : Color(hex: 0xFFD84315)
                let ringPath = Path { p in
                    p.addEllipse(in: CGRect(x: w * 0.12, y: h * 0.12, width: w * 0.76, height: h * 0.76))
                }
                context.stroke(ringPath, with: .color(pCol), lineWidth: w * 0.18)

            } else if ingredientId.contains("039") || ingredientId.contains("053") || ingredientId.contains("037") {
                // Pineapple Chunk / Corn
                let chunk = Path { p in
                    p.move(to: CGPoint(x: w * 0.2, y: h * 0.3))
                    p.addLine(to: CGPoint(x: w * 0.8, y: h * 0.2))
                    p.addLine(to: CGPoint(x: w * 0.7, y: h * 0.8))
                    p.addLine(to: CGPoint(x: w * 0.25, y: h * 0.75))
                    p.closeSubpath()
                }
                context.fill(chunk, with: .color(Color(hex: 0xFFFFD54F)))
                context.stroke(chunk, with: .color(Color(hex: 0xFFF57F17)), lineWidth: w * 0.06)

            } else if ingredientId.contains("041") || ingredientId.contains("042") || ingredientId.contains("044") {
                // Bacon / Ham Slice
                let hamRect = CGRect(x: w * 0.12, y: h * 0.25, width: w * 0.76, height: h * 0.50)
                context.fill(Path(roundedRect: hamRect, cornerRadius: 6), with: .color(Color(hex: 0xFFF06292)))
                context.stroke(Path(roundedRect: hamRect, cornerRadius: 6), with: .color(Color(hex: 0xFFC2185B)), lineWidth: w * 0.06)

            } else if ingredientId.contains("050") {
                // Strawberry
                let berryPath = Path { p in
                    p.move(to: CGPoint(x: w * 0.5, y: h * 0.88))
                    p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.25), control: CGPoint(x: w * 0.08, y: h * 0.45))
                    p.addQuadCurve(to: CGPoint(x: w * 0.5, y: h * 0.88), control: CGPoint(x: w * 0.92, y: h * 0.45))
                    p.closeSubpath()
                }
                context.fill(berryPath, with: .color(Color(hex: 0xFFD32F2F)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.38, y: h * 0.16, width: w * 0.24, height: h * 0.14)), with: .color(Color(hex: 0xFF388E3C)))

            } else {
                // Sweet Candy Star
                let starPath = Path { p in
                    let numPoints = 5
                    let outerR = w * 0.44
                    let innerR = w * 0.22
                    for i in 0..<(numPoints * 2) {
                        let r = (i % 2 == 0) ? outerR : innerR
                        let angle = Double(i) * .pi / Double(numPoints) - .pi / 2
                        let px = center.x + CGFloat(cos(angle)) * r
                        let py = center.y + CGFloat(sin(angle)) * r
                        if i == 0 { p.move(to: CGPoint(x: px, y: py)) }
                        else { p.addLine(to: CGPoint(x: px, y: py)) }
                    }
                    p.closeSubpath()
                }
                context.fill(starPath, with: .color(Color(hex: 0xFFFFD54F)))
                context.stroke(starPath, with: .color(Color(hex: 0xFFF57F17)), lineWidth: w * 0.06)
            }
        }
        .frame(width: size, height: size)
    }
}

/**
 * 2D Cartoon Pizza Thumbnail Renderer for 20 master recipes on iOS.
 */
public struct CartoonPizzaThumbnail: View {
    public let recipeId: String
    public var size: CGFloat = 80

    public init(recipeId: String, size: CGFloat = 80) {
        self.recipeId = recipeId
        self.size = size
    }

    public var body: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let center = CGPoint(x: w / 2, y: h / 2)
            let outerRadius = w * 0.46

            // 1. BASE CRUST
            switch recipeId {
            case "R-03": // Watermelon Green Rind
                context.fill(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color(hex: 0xFF2E7D32)))
                let inner1 = outerRadius * 0.90
                context.fill(Path(ellipseIn: CGRect(x: center.x - inner1, y: center.y - inner1, width: inner1 * 2, height: inner1 * 2)), with: .color(Color(hex: 0xFF81C784)))
                let inner2 = outerRadius * 0.82
                context.fill(Path(ellipseIn: CGRect(x: center.x - inner2, y: center.y - inner2, width: inner2 * 2, height: inner2 * 2)), with: .color(Color(hex: 0xFFE53935)))
            case "R-04": // Chocolate Crust
                context.fill(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color(hex: 0xFF3E2723)))
                let inR = outerRadius * 0.85
                context.fill(Path(ellipseIn: CGRect(x: center.x - inR, y: center.y - inR, width: inR * 2, height: inR * 2)), with: .color(Color(hex: 0xFF5D4037)))
            case "R-08": // Vampire Dark Crust
                context.fill(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color(hex: 0xFF212121)))
                let inR = outerRadius * 0.85
                context.fill(Path(ellipseIn: CGRect(x: center.x - inR, y: center.y - inR, width: inR * 2, height: inR * 2)), with: .color(Color(hex: 0xFFB71C1C)))
            case "R-09": // Unicorn Rainbow Crust
                context.fill(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color(hex: 0xFFBA68C8)))
                let inR = outerRadius * 0.85
                context.fill(Path(ellipseIn: CGRect(x: center.x - inR, y: center.y - inR, width: inR * 2, height: inR * 2)), with: .color(Color(hex: 0xFFF8BBD0)))
            case "R-20": // Galaxy Dark Indigo Crust
                context.fill(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color(hex: 0xFF1A237E)))
                let inR = outerRadius * 0.85
                context.fill(Path(ellipseIn: CGRect(x: center.x - inR, y: center.y - inR, width: inR * 2, height: inR * 2)), with: .color(Color(hex: 0xFF0D47A1)))
            case "R-18": // Volcano Fire Crust
                context.fill(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color(hex: 0xFFBF360C)))
                let inR = outerRadius * 0.85
                context.fill(Path(ellipseIn: CGRect(x: center.x - inR, y: center.y - inR, width: inR * 2, height: inR * 2)), with: .color(Color(hex: 0xFFFF5722)))
            default: // Golden Standard Crust
                context.fill(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color(hex: 0xFFF4A261)))
                let cheeseR = outerRadius * 0.80
                context.fill(Path(ellipseIn: CGRect(x: center.x - cheeseR, y: center.y - cheeseR, width: cheeseR * 2, height: cheeseR * 2)), with: .color(Color(hex: 0xFFFFD54F)))
            }

            // 2. RECIPE SPECIFIC TOPPINGS
            switch recipeId {
            case "R-01": // Margherita: Red sauce, mozzarella blobs, green basil
                let sR = outerRadius * 0.74
                context.fill(Path(ellipseIn: CGRect(x: center.x - sR, y: center.y - sR, width: sR * 2, height: sR * 2)), with: .color(Color(hex: 0xFFE53935)))
                // Mozzarella
                context.fill(Path(ellipseIn: CGRect(x: w * 0.32, y: h * 0.35, width: w * 0.22, height: w * 0.22)), with: .color(Color(hex: 0xFFFFFDE7)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.54, y: h * 0.45, width: w * 0.20, height: w * 0.20)), with: .color(Color(hex: 0xFFFFFDE7)))
                // Basil
                context.fill(Path(ellipseIn: CGRect(x: w * 0.44, y: h * 0.30, width: w * 0.12, height: w * 0.12)), with: .color(Color(hex: 0xFF2E7D32)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.34, y: h * 0.58, width: w * 0.12, height: w * 0.12)), with: .color(Color(hex: 0xFF388E3C)))

            case "R-02": // Pepperoni: 5 red pepperoni circles
                let pepPos: [CGPoint] = [
                    CGPoint(x: w * 0.35, y: h * 0.35),
                    CGPoint(x: w * 0.65, y: h * 0.35),
                    CGPoint(x: w * 0.50, y: h * 0.52),
                    CGPoint(x: w * 0.34, y: h * 0.65),
                    CGPoint(x: w * 0.66, y: h * 0.65)
                ]
                for p in pepPos {
                    let r = w * 0.09
                    context.fill(Path(ellipseIn: CGRect(x: p.x - r, y: p.y - r, width: r * 2, height: r * 2)), with: .color(Color(hex: 0xFFD32F2F)))
                    context.fill(Path(ellipseIn: CGRect(x: p.x - 2, y: p.y - 2, width: 4, height: 4)), with: .color(Color(hex: 0xFFFF8A80)))
                }

            case "R-03": // Watermelon seeds
                let seeds: [CGPoint] = [
                    CGPoint(x: w * 0.38, y: h * 0.38),
                    CGPoint(x: w * 0.62, y: h * 0.38),
                    CGPoint(x: w * 0.50, y: h * 0.52),
                    CGPoint(x: w * 0.36, y: h * 0.62),
                    CGPoint(x: w * 0.64, y: h * 0.62)
                ]
                for s in seeds {
                    context.fill(Path(ellipseIn: CGRect(x: s.x - 3, y: s.y - 5, width: 6, height: 10)), with: .color(Color(hex: 0xFF212121)))
                }

            case "R-04": // Marshmallows & Gummy Candies
                context.fill(Path(roundedRect: CGRect(x: w * 0.34, y: h * 0.34, width: w * 0.14, height: w * 0.14), cornerRadius: 3), with: .color(.white))
                context.fill(Path(roundedRect: CGRect(x: w * 0.54, y: h * 0.52, width: w * 0.14, height: w * 0.14), cornerRadius: 3), with: .color(.white))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.58, y: h * 0.34, width: w * 0.11, height: w * 0.11)), with: .color(Color(hex: 0xFFFF4081)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.36, y: h * 0.56, width: w * 0.11, height: w * 0.11)), with: .color(Color(hex: 0xFF00E5FF)))

            case "R-06": // Tropical Hawaiian: Ham & Pineapple
                context.fill(Path(roundedRect: CGRect(x: w * 0.32, y: h * 0.35, width: w * 0.14, height: w * 0.12), cornerRadius: 3), with: .color(Color(hex: 0xFFF48FB1)))
                context.fill(Path(roundedRect: CGRect(x: w * 0.55, y: h * 0.55, width: w * 0.14, height: w * 0.12), cornerRadius: 3), with: .color(Color(hex: 0xFFF48FB1)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.56, y: h * 0.36, width: w * 0.14, height: w * 0.14)), with: .color(Color(hex: 0xFFFFD54F)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.36, y: h * 0.54, width: w * 0.14, height: w * 0.14)), with: .color(Color(hex: 0xFFFFD54F)))

            case "R-14": // Breakfast Egg & Bacon
                context.fill(Path(roundedRect: CGRect(x: w * 0.28, y: h * 0.60, width: w * 0.44, height: h * 0.10), cornerRadius: 4), with: .color(Color(hex: 0xFFC2185B)))
                // Sunny fried egg
                context.fill(Path(ellipseIn: CGRect(x: w * 0.35, y: h * 0.30, width: w * 0.30, height: w * 0.30)), with: .color(.white))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.42, y: h * 0.37, width: w * 0.16, height: w * 0.16)), with: .color(Color(hex: 0xFFFFB300)))

            case "R-20": // Cosmic Galaxy: Stars & Nebula
                context.fill(Path(ellipseIn: CGRect(x: w * 0.32, y: h * 0.32, width: w * 0.10, height: w * 0.10)), with: .color(Color(hex: 0xFFFFD700)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.62, y: h * 0.40, width: w * 0.10, height: w * 0.10)), with: .color(.white))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.45, y: h * 0.62, width: w * 0.10, height: w * 0.10)), with: .color(Color(hex: 0xFF80D8FF)))

            default:
                // Universal yummy pizza toppings
                context.fill(Path(ellipseIn: CGRect(x: w * 0.36, y: h * 0.38, width: w * 0.12, height: w * 0.12)), with: .color(Color(hex: 0xFFD32F2F)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.58, y: h * 0.42, width: w * 0.12, height: w * 0.12)), with: .color(Color(hex: 0xFF2E7D32)))
                context.fill(Path(ellipseIn: CGRect(x: w * 0.46, y: h * 0.60, width: w * 0.12, height: w * 0.12)), with: .color(Color(hex: 0xFFFFB300)))
            }

            // Outline
            context.stroke(Path(ellipseIn: CGRect(x: center.x - outerRadius, y: center.y - outerRadius, width: outerRadius * 2, height: outerRadius * 2)), with: .color(Color.black.opacity(0.35)), lineWidth: 3)
        }
        .frame(width: size, height: size)
    }
}
