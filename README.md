# Pizza Cooking World — iOS

A fun and engaging **Kids Pizza Cooking Game** built with **Native Swift** and **SwiftUI**. The application runs **100% Offline** with zero backend, zero external asset downloads, no advertisements, and zero tracking — completely safe for toddlers and children.

---

## 🌟 Key Features (100% Feature Parity with Android)

- **20 Diverse Master Pizza Recipes (R-01 through R-20):**
  - Complete recipe catalog spanning traditional favorites (Margherita, Pepperoni, Hawaii, BBQ Chicken, Seafood...) to sweet dessert creations (Chocolate Berry, Marshmallow, Rainbow Unicorn, Summer Watermelon...).
  - Child-friendly visual menu with colorful 2D cartoon illustrations, clear English recipe titles, and detailed descriptions.
- **Progressive Difficulty Tiers:**
  - **Level 1 (Easy - 6 Recipes):** Designed for young toddlers with sparkling target rings, quick tap interactions, and automatic 3-star baking.
  - **Level 2 (Medium - 9 Recipes):** Requires $\ge 75\%$ sauce coverage, recipe-matching toppings, and standard prep steps.
  - **Level 3 (Hard / Challenge - 5 Recipes):** Requires $\ge 85\%$ sauce coverage, precision topping placement, and an interactive **Heat Needle Gauge Minigame**: players tap "Take Pizza Out Now!" when the needle enters the golden star zone.
  - **No-Bake Category (2 Recipes):** Chilled dessert treats (Summer Watermelon Pizza, Berry Fruit Tart) that skip oven baking.
- **Rich Cartoon Visual Art:**
  - Italian Pizzeria shopfront with red-and-white striped awning, sunny blue sky, and fluffy clouds.
  - Kitchen background featuring an outdoor window view, green potted basil plant, and warm polished oak countertops.
  - True 1:1 circular wooden cutting board and pizza dough, paired with vibrant custom SwiftUI Shape topping graphics.
- **Procedural BGM Synthesizer (100% Offline):**
  - Built-in polyphonic Italian marimba & accordion melody generated at runtime via native `AVAudioEngine` / `AVAudioPlayer` procedural synthesizer.
  - Zero external MP3/audio files required; ultra-low memory footprint.
  - Audio Mute / Unmute controls accessible across all screens.

---

## 🛠️ Architecture & Tech Stack

- **Language:** Swift 5.9+ / Swift 6
- **UI Framework:** SwiftUI (iOS 17.0+ / iPadOS 17.0+)
- **Orientation:** Fixed Landscape Only (`UIInterfaceOrientationLandscapeLeft`, `UIInterfaceOrientationLandscapeRight`)
- **Architecture Pattern:** MVVM + Unidirectional Data Flow (UDF) with `ObservableObject` / `@Published`
- **Project Tooling:** Swift Package Manager (`Package.swift`) & XcodeGen (`project.yml`)
- **Quality Assurance:** Comprehensive XCTest Suite

---

## 🚀 Getting Started on macOS (Xcode)

### Prerequisites
- macOS Sonoma / Sequoia with Xcode 15 or 16.
- iPhone or iPad Simulator / Device running iOS 17+.

### Building and Running
1. Clone the repository:
   ```bash
   git clone https://github.com/minhlai1123/cookkingpizza-ios.git
   cd cookkingpizza-ios
   ```
2. Open directly via Swift Package Manager:
   ```bash
   open Package.swift
   ```
   Or generate an Xcode project file using [XcodeGen](https://github.com/yonaskolb/XcodeGen):
   ```bash
   xcodegen generate
   open PizzaCookingWorld.xcodeproj
   ```
3. Select scheme `PizzaCookingWorld` and choose an iPhone or iPad Simulator in Landscape orientation.
4. Press `Cmd + R` to Build & Run.
5. Press `Cmd + U` or run `swift test` to execute the XCTest suite.

---

## 📁 Directory Structure

```
├── Sources/
│   ├── App/
│   │   └── PizzaCookingWorldApp.swift    # App Entry Point & Screen Navigation
│   ├── Core/
│   │   ├── ColorTheme.swift              # Cartoon Color Palette
│   │   ├── Constants.swift
│   │   └── SoundEffects.swift            # Procedural Audio & BGM Synthesizer
│   ├── Data/
│   │   ├── Models/                       # Ingredient, Recipe, CookingStep, SaveData, Tool
│   │   ├── Repository/                   # Repositories & Recipe Validator
│   │   └── Storage/                      # Local JSON Storage Engine
│   ├── Domain/
│   │   ├── Creative/                     # Creative Cooking Session
│   │   ├── Scoring/                      # Scoring Engine (Stars & Accuracy)
│   │   └── StateMachine/                 # Pizza State Machine & Flow
│   ├── Resources/
│   │   └── Data/                         # Master Catalogs JSON (112 ingredients, 20 recipes, tools)
│   └── Views/
│       ├── CartoonVisuals.swift          # SwiftUI Cartoon Drawing Components
│       ├── KitchenView.swift             # Kitchen Screen & Oven Minigame
│       ├── MainMenuView.swift            # Pizzeria Cartoon Shopfront
│       ├── RecipeSelectionView.swift     # 20 Master Recipes & Difficulty Filter
│       └── RootContentView.swift
├── Tests/
│   └── PizzaCookingWorldTests/           # XCTest Test Suite
├── Package.swift                         # SPM Manifest
├── project.yml                           # XcodeGen Spec
├── Info.plist                            # Landscape Configuration & Permissions
└── README.md
```

---

## 📄 License
Copyright © Pizza Cooking World. All rights reserved.
