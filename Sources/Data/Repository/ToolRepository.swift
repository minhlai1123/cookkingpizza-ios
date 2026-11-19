import Foundation

public final class ToolRepository {
    public static let shared = ToolRepository()

    private let masterTools: [String: Tool]

    private init() {
        let tools: [Tool] = [
            Tool(toolId: "TOOL-001", name: "Rolling Pin", category: "PREPARATION", actions: ["ROLL", "FLATTEN"], applicableIngredients: ["ING-001", "ING-003", "ING-004", "ING-005", "ING-007", "ING-009", "ING-010"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-002", name: "Chef Knife", category: "CUTTING", actions: ["SLICE", "CHOP", "NOTCH"], applicableIngredients: ["ING-002", "ING-030", "ING-031", "ING-032", "ING-033", "ING-040", "ING-041", "ING-050", "ING-051"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-003", name: "Wire Whisk", category: "MIXING", actions: ["WHISK", "BEAT", "FROTH"], applicableIngredients: ["ING-013", "ING-017"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-004", name: "Glass Blender", category: "APPLIANCE", actions: ["BLEND", "PUREE"], applicableIngredients: ["ING-013", "ING-050", "ING-051", "ING-052"], interactionType: "HOLD"),
            Tool(toolId: "TOOL-005", name: "Box Grater", category: "GRATING", actions: ["GRATE", "SHRED"], applicableIngredients: ["ING-021", "ING-022", "ING-025", "ING-026"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-006", name: "Sauce Ladle", category: "SPREADING", actions: ["SCOOP", "SPREAD", "SWIRL"], applicableIngredients: ["ING-011", "ING-012", "ING-013", "ING-014", "ING-015", "ING-018", "ING-020"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-007", name: "Pizza Peel", category: "BAKING", actions: ["SLIDE_IN", "RETRIEVE"], applicableIngredients: [], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-008", name: "Roller Cutter", category: "SERVING", actions: ["SLICE_WHEEL", "DIVIDE"], applicableIngredients: [], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-009", name: "Piping Bag", category: "DECORATING", actions: ["PIPE", "DRAW_PATTERN"], applicableIngredients: ["ING-060"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-010", name: "Squeeze Bottle", category: "DISPENSING", actions: ["SQUEEZE", "ZIGZAG"], applicableIngredients: ["ING-016", "ING-019", "ING-061"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-011", name: "Honey Dipper", category: "DRIZZLING", actions: ["TWIRL", "DRIZZLE"], applicableIngredients: ["ING-062"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-012", name: "Shaped Cookie Cutters", category: "SHAPING", actions: ["STAMP", "PRESS_CUT"], applicableIngredients: ["ING-006", "ING-009", "ING-023"], interactionType: "TAP"),
            Tool(toolId: "TOOL-013", name: "Glass Popcorn Pan", category: "COOKING", actions: ["HEAT_POP", "SHAKE"], applicableIngredients: ["ING-070"], interactionType: "HOLD"),
            Tool(toolId: "TOOL-014", name: "Wooden Truffle Slicer", category: "SHAVING", actions: ["SHAVE", "FLAKE"], applicableIngredients: ["ING-035"], interactionType: "SWIPE"),
            Tool(toolId: "TOOL-015", name: "Silicone Chili Tongs", category: "HANDLING", actions: ["PICK_PLACE", "PINCH"], applicableIngredients: ["ING-036", "ING-037", "ING-038"], interactionType: "DRAG_AND_DROP")
        ]
        var map: [String: Tool] = [:]
        for t in tools {
            map[t.toolId] = t
        }
        self.masterTools = map
    }

    public func getAllTools() -> [Tool] {
        return Array(masterTools.values)
    }

    public func getToolById(_ id: String) -> Tool? {
        return masterTools[id]
    }

    public func hasTool(_ id: String) -> Bool {
        return masterTools[id] != nil
    }
}
