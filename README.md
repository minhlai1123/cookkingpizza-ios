# Pizza Cooking World — iOS

Trò chơi nấu ăn Pizza dành cho trẻ em (Kids Cooking Game) được phát triển bằng **Native Swift** và **SwiftUI**. Game hoạt động **100% Offline**, không yêu cầu kết nối mạng, không quảng cáo, và bảo đảm an toàn tuyệt đối cho trẻ nhỏ.

---

## 🌟 Tính Năng Nổi Bật (Đồng Bộ 100% với Bản Android)

- **20 Món Pizza Đa Dạng (R-01 đến R-20):**
  - Đầy đủ các công thức từ Pizza truyền thống (Margherita, Pepperoni, Hawaii, BBQ Chicken, Hải sản...) đến các món tráng miệng & sáng tạo độc đáo (Chocolate Berry, Marshmallow, Rainbow Unicorn, Trái cây mùa hè...).
  - Menu lựa chọn công thức trực quan với hình minh họa hoạt hình bắt mắt, tên tiếng Việt thân thiện với trẻ nhỏ.
- **Hệ Thống Phân Cấp Độ (Difficulty Levels):**
  - **Level 1 (Dễ):** Hướng dẫn vòng sáng mục tiêu (Sparkling rings), thao tác chạm đơn giản, tự động canh lò chuẩn 3 sao.
  - **Level 2 (Vừa):** Cần phủ đều sốt phô mai $\ge 75\%$, phân bổ topping đúng vị trí theo công thức.
  - **Level 3 (Thử thách):** Phủ sốt $\ge 85\%$ và minigame **Canh Lửa Lò Nướng (Heat Needle Gauge)**: bấm "Lấy bánh ra ngay!" khi kim nhiệt độ rơi vào vùng sao vàng để đạt điểm tuyệt đối.
  - **No-Bake:** Nhóm món tráng miệng mát lạnh không cần nướng (Watermelon Pizza, Berry Tart).
- **Giao Diện Hoạt Hình (Cartoon Visuals):**
  - Khung cảnh tiệm bánh Pizzeria phong cách hoạt hình với mái che sọc đỏ trắng, mây trời rực rỡ.
  - Màn hình nhà bếp nhìn ra cửa sổ trời xanh, chậu cây húng tây xanh mát, bàn gỗ sồi ấm áp.
  - Thớt và đế pizza tròn đều tỷ lệ 1:1, các loại topping (xúc xích, nấm, ớt chuông, ô liu, tôm, phô mai...) vẽ bằng SwiftUI Shape/Canvas sinh động.
- **Nhạc Nền & Hiệu Ứng Âm Thanh BGM Tự Sinh (Procedural BGM Synthesizer):**
  - Tự động tổng hợp âm thanh đa âm phong cách Marimba/Accordion Ý tươi vui qua `AVAudioEngine` / `AVAudioPlayer` procedural synthesizer.
  - Hoạt động offline 100%, không cần tải file âm thanh nặng từ bên ngoài.
  - Nút bật/tắt âm thanh (Mute/Unmute) tiện lợi ở mọi màn hình.

---

## 🛠️ Công Nghệ & Kiến Trúc

- **Ngôn ngữ:** Swift 5.9+ / Swift 6
- **UI Framework:** SwiftUI (iOS 17.0+ / iPadOS 17.0+)
- **Định dạng màn hình:** Khóa cố định màn hình ngang (Landscape Only)
- **Kiến trúc:** MVVM + Unidirectional Data Flow (UDF) với `ObservableObject` / `@Published`
- **Quản lý dự án:** Swift Package Manager (`Package.swift`) & XcodeGen (`project.yml`)
- **Kiểm thử:** XCTest Suite (Bao phủ Logic, State Machine, Recipe Validator, Scoring Engine)

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Trên macOS (Xcode)

### 1. Mở dự án
1. Clone repository về máy:
   ```bash
   git clone https://github.com/minhlai1123/cookkingpizza-ios.git
   cd cookkingpizza-ios
   ```
2. Mở trực tiếp bằng Xcode qua Swift Package Manager:
   ```bash
   open Package.swift
   ```
   Hoặc tạo project Xcode bằng [XcodeGen](https://github.com/yonaskolb/XcodeGen):
   ```bash
   xcodegen generate
   open PizzaCookingWorld.xcodeproj
   ```

### 2. Chạy Ứng Dụng
- Chọn scheme `PizzaCookingWorld`.
- Chọn thiết bị Simulator iPhone hoặc iPad (chế độ Landscape).
- Bấm `Cmd + R` để Build & Run.

### 3. Chạy Unit Tests
```bash
swift test
# hoặc nhấn Cmd + U trong Xcode
```

---

## 📁 Cấu Trúc Thư Mục

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
│   │   └── Data/                         # Master Catalogs JSON (112 nguyên liệu, 20 recipes, tools)
│   └── Views/
│       ├── CartoonVisuals.swift          # SwiftUI Cartoon Drawing Components
│       ├── KitchenScreen.swift           # Kitchen Screen & Oven Minigame
│       ├── MainMenuView.swift            # Pizzeria Cartoon Shopfront
│       ├── RecipeSelectionView.swift     # 20 Recipes & Difficulty Tiers
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
Dự án được bảo hộ bản quyền cho Pizza Cooking World.
