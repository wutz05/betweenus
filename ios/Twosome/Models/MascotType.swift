import Foundation

nonisolated enum MascotType: String, Codable, CaseIterable, Sendable, Identifiable {
    case bears
    case frogs
    case penguins
    case cats

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .bears: return "Bears"
        case .frogs: return "Frogs"
        case .penguins: return "Penguins"
        case .cats: return "Cats"
        }
    }

    var imageName: String {
        switch self {
        case .bears: return "bears_together"
        case .frogs: return "frogs_together"
        case .penguins: return "penguins_together"
        case .cats: return "cats_together"
        }
    }

    var emoji: String {
        switch self {
        case .bears: return "🐻"
        case .frogs: return "🐸"
        case .penguins: return "🐧"
        case .cats: return "🐱"
        }
    }
}
