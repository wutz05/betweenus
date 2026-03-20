import Foundation

nonisolated struct WidgetConfig: Codable, Sendable {
    var showDailyQuestion: Bool
    var showDateSpark: Bool
    var showMemoryFlash: Bool
    var showCountdown: Bool
    var showDaysTogether: Bool
    var showWishlist: Bool

    init() {
        self.showDailyQuestion = true
        self.showDateSpark = true
        self.showMemoryFlash = true
        self.showCountdown = false
        self.showDaysTogether = false
        self.showWishlist = false
    }
}

nonisolated struct WishlistItem: Codable, Identifiable, Sendable {
    let id: UUID
    var title: String
    var category: WishlistCategory
    var isCompleted: Bool

    init(title: String, category: WishlistCategory) {
        self.id = UUID()
        self.title = title
        self.category = category
        self.isCompleted = false
    }

    nonisolated enum WishlistCategory: String, Codable, CaseIterable, Sendable {
        case dateIdea = "Date Ideas"
        case travel = "Travel"
        case restaurant = "Restaurants"
        case other = "Other"
    }
}
