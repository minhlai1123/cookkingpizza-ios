import SwiftUI

public extension Color {
    // Master Color Palette from GDD & Phase 1.3.0 Visual Design System
    static let warmTomatoRed = Color(hex: 0xE53935)
    static let goldenCrust = Color(hex: 0xFFFFB300)
    static let cheeseYellow = Color(hex: 0xFFF176)
    static let basilFreshGreen = Color(hex: 0x43A047)
    static let warmKitchenWood = Color(hex: 0x5D4037)
    static let polishedOakWood = Color(hex: 0x8D6E63)
    static let warmMarbleCream = Color(hex: 0xFFF8E1)
    static let creamDoughWhite = Color(hex: 0xFDF8F0)
    static let gentleBlue = Color(hex: 0x4EA8DE)
    static let darkCharcoal = Color(hex: 0x212121)
    static let crustBrownDark = Color(hex: 0x3E2723)
    
    // Phase 1.3.0 Environment & UI Tokens
    static let pastelKitchenTile = Color(hex: 0xE0F2F1)
    static let brushedSteelGray = Color(hex: 0xECEFF1)
    static let ovenHearth = Color(hex: 0x263238)
    static let starGoldGlory = Color(hex: 0xFFD54F)
    static let playfulCyan = Color(hex: 0x00ACC1)
    static let magicViolet = Color(hex: 0x8E24AA)
    static let softCoralAlert = Color(hex: 0xFFFF8A80)
    
    init(hex: UInt32, alpha: Double = 1.0) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(.sRGB, red: r, green: g, blue: b, opacity: alpha)
    }
}
