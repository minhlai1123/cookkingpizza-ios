import SwiftUI

public enum RecipeFilterCategory: String, CaseIterable, Identifiable {
    case all = "ALL"
    case easy = "EASY"
    case medium = "MEDIUM"
    case hard = "HARD"
    case noBake = "NO_BAKE"
    
    public var id: String { rawValue }
    
    public var labelVi: String {
        switch self {
        case .all: return "Tất Cả (20)"
        case .easy: return "Dễ (6)"
        case .medium: return "Vừa (9)"
        case .hard: return "Thử Thách (5)"
        case .noBake: return "Không Cần Nướng (2)"
        }
    }
    
    public var icon: String {
        switch self {
        case .all: return "🌟"
        case .easy: return "⭐"
        case .medium: return "⭐⭐"
        case .hard: return "⭐⭐⭐"
        case .noBake: return "🍓"
        }
    }
}

public struct RecipeLocalizedInfo {
    public let recipeId: String
    public let nameVi: String
    public let nameEn: String
    public let difficultyTier: Int // 1: Easy, 2: Medium, 3: Hard
    public let difficultyLabelVi: String
    public let badgeColor: Color
    public let descriptionVi: String
}

public struct RecipeMetadataRegistry {
    private static let registry: [String: RecipeLocalizedInfo] = [
        "R-01": RecipeLocalizedInfo(recipeId: "R-01", nameVi: "Margherita Cổ Điển", nameEn: "Classic Margherita", difficultyTier: 1, difficultyLabelVi: "⭐ DỄ", badgeColor: Color(hex: 0x4CAF50), descriptionVi: "Xốt cà chua tươi, phô mai dẻo dai và lá húng quế thơm phức."),
        "R-02": RecipeLocalizedInfo(recipeId: "R-02", nameVi: "Xúc Xích Pepperoni", nameEn: "Pepperoni Supreme", difficultyTier: 1, difficultyLabelVi: "⭐ DỄ", badgeColor: Color(hex: 0x4CAF50), descriptionVi: "Xúc xích cay giòn, ớt chuông xanh và ô-liu đen thơm ngon."),
        "R-03": RecipeLocalizedInfo(recipeId: "R-03", nameVi: "Dưa Hấu Mát Lạnh", nameEn: "Summer Watermelon", difficultyTier: 1, difficultyLabelVi: "⭐ DỄ", badgeColor: Color(hex: 0x4CAF50), descriptionVi: "Đế dưa hấu mát ngọt, xốt dừa cầu vồng, tráng miệng không cần nướng!"),
        "R-04": RecipeLocalizedInfo(recipeId: "R-04", nameVi: "Kẹo Dẻo & Kẹo Bông", nameEn: "Sweet Candy & Marshmallow", difficultyTier: 1, difficultyLabelVi: "⭐ DỄ", badgeColor: Color(hex: 0x4CAF50), descriptionVi: "Bánh quy sô-cô-la đen, kẹo gấu dẻo và kẹo bông xốp ngọt ngào."),
        "R-05": RecipeLocalizedInfo(recipeId: "R-05", nameVi: "4 Vị Phô Mai Béo", nameEn: "Four Cheese Formaggi", difficultyTier: 1, difficultyLabelVi: "⭐ DỄ", badgeColor: Color(hex: 0x4CAF50), descriptionVi: "Hòa quyện 4 loại phô mai thơm lừng, kéo sợi cực đã!"),
        "R-06": RecipeLocalizedInfo(recipeId: "R-06", nameVi: "Dứa Hawaii Nhiệt Đới", nameEn: "Tropical Hawaiian Breeze", difficultyTier: 1, difficultyLabelVi: "⭐ DỄ", badgeColor: Color(hex: 0x4CAF50), descriptionVi: "Thịt nguội hồng hào cùng những lát dứa vàng tươi chua ngọt."),
        "R-07": RecipeLocalizedInfo(recipeId: "R-07", nameVi: "Kho Báu Cướp Biển", nameEn: "Ahoy Pirate Treasure", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Truy tìm đồng tiền vàng sô-cô-la trên chiếc pizza cướp biển kỳ bí!"),
        "R-08": RecipeLocalizedInfo(recipeId: "R-08", nameVi: "Halloween Dracula", nameEn: "Spooky Halloween Vampire", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Đế đen huyền bí, xốt đỏ ma mị và những chú dơi ngộ nghĩnh."),
        "R-09": RecipeLocalizedInfo(recipeId: "R-09", nameVi: "Kỳ Lân Cầu Vồng", nameEn: "Magical Rainbow Unicorn", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Xốt dâu tây pastel, ngôi sao lấp lánh và sừng kỳ lân diệu kỳ!"),
        "R-10": RecipeLocalizedInfo(recipeId: "R-10", nameVi: "Giáng Sinh Tuyết Trắng", nameEn: "Winter Wonderland Christmas", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Phô mai tuyết trắng muốt, cây thông xanh và quả châu đỏ rực."),
        "R-11": RecipeLocalizedInfo(recipeId: "R-11", nameVi: "Gà Nướng Sốt BBQ", nameEn: "Gourmet BBQ Chicken", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Thịt gà nướng mềm ngậy cùng dòng xốt BBQ đậm đà thơm lừng."),
        "R-12": RecipeLocalizedInfo(recipeId: "R-12", nameVi: "Bạch Tuộc Takoyaki", nameEn: "Japanese Takoyaki", difficultyTier: 3, difficultyLabelVi: "⭐⭐⭐ THỬ THÁCH", badgeColor: Color(hex: 0xE91E63), descriptionVi: "Phong cách Nhật Bản với bạch tuộc giòn sần sật và rong biển thơm."),
        "R-13": RecipeLocalizedInfo(recipeId: "R-13", nameVi: "Bò Taco Mexico", nameEn: "Fiesta Mexican Taco", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Thịt bò băm đậm vị cay nhẹ, bánh ngô giòn tan và xốt salsa."),
        "R-14": RecipeLocalizedInfo(recipeId: "R-14", nameVi: "Bữa Sáng Trứng Ốp La", nameEn: "Sunny Breakfast Egg & Bacon", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Trứng lòng đào vàng ươm cùng thịt xông khói giòn rụm bổ dưỡng."),
        "R-15": RecipeLocalizedInfo(recipeId: "R-15", nameVi: "Nấm Rừng & Truffle", nameEn: "Wild Forest Mushroom", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Nấm rừng tươi ngon kết hợp hương dầu nấm Truffle sang trọng."),
        "R-16": RecipeLocalizedInfo(recipeId: "R-16", nameVi: "Lễ Hội Xiếc Rực Rỡ", nameEn: "Circus Fun Carnival", difficultyTier: 3, difficultyLabelVi: "⭐⭐⭐ THỬ THÁCH", badgeColor: Color(hex: 0xE91E63), descriptionVi: "Bỏng ngô ngọt giòn, kẹo rực rỡ sắc màu như đoàn xiếc vui nhộn!"),
        "R-17": RecipeLocalizedInfo(recipeId: "R-17", nameVi: "Tart Dâu Trái Cây", nameEn: "Berry Berry Fruit Tart", difficultyTier: 2, difficultyLabelVi: "⭐⭐ VỪA", badgeColor: Color(hex: 0xFF9800), descriptionVi: "Đế bánh tart mềm, kem ngọt, ngập tràn dâu tây tươi mát lạnh!"),
        "R-18": RecipeLocalizedInfo(recipeId: "R-18", nameVi: "Núi Lửa Cay Bùng Nổ", nameEn: "Volcano Spicy Pepper", difficultyTier: 3, difficultyLabelVi: "⭐⭐⭐ THỬ THÁCH", badgeColor: Color(hex: 0xE91E63), descriptionVi: "Ớt chuông lửa bốc khói cay nồng dành cho các đầu bếp dũng cảm!"),
        "R-19": RecipeLocalizedInfo(recipeId: "R-19", nameVi: "Vườn Hoa Rau Củ", nameEn: "Garden Veggie Bloom", difficultyTier: 3, difficultyLabelVi: "⭐⭐⭐ THỬ THÁCH", badgeColor: Color(hex: 0xE91E63), descriptionVi: "Xếp bí ngòi, cà chua bi và ớt chuông thành đóa hoa tuyệt đẹp."),
        "R-20": RecipeLocalizedInfo(recipeId: "R-20", nameVi: "Thiên Hà Vũ Trụ", nameEn: "Royal Galaxy Cosmic", difficultyTier: 3, difficultyLabelVi: "⭐⭐⭐ THỬ THÁCH", badgeColor: Color(hex: 0xE91E63), descriptionVi: "Đế thiên hà màu tím thẫm, rắc bụi sao vàng và bụi vũ trụ lấp lánh!")
    ]
    
    public static func getInfo(for recipeId: String) -> RecipeLocalizedInfo {
        return registry[recipeId] ?? RecipeLocalizedInfo(
            recipeId: recipeId,
            nameVi: "Pizza Thơm Ngon",
            nameEn: "Delicious Pizza",
            difficultyTier: 1,
            difficultyLabelVi: "⭐ DỄ",
            badgeColor: Color(hex: 0x4CAF50),
            descriptionVi: "Món pizza hảo hạng dành cho bé trổ tài đầu bếp nhí!"
        )
    }
}
