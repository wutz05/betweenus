import Foundation
import WidgetKit

nonisolated let appGroupID = "group.app.rork.4t86sqjc72fxll6068lk4"

nonisolated struct SharedWidgetData: Codable, Sendable {
    var myName: String
    var partnerName: String
    var anniversaryDate: Date?
    var distanceKm: Int?
    var latestMessage: String?
    var latestMessageSender: String?
    var latestMessageDate: Date?
    var upcomingEvents: [SharedEvent]

    init() {
        self.myName = ""
        self.partnerName = ""
        self.anniversaryDate = nil
        self.distanceKm = nil
        self.latestMessage = nil
        self.latestMessageSender = nil
        self.latestMessageDate = nil
        self.upcomingEvents = []
    }
}

nonisolated struct SharedEvent: Codable, Sendable, Identifiable {
    let id: UUID
    let title: String
    let date: Date
    let emoji: String

    init(id: UUID = UUID(), title: String, date: Date, emoji: String) {
        self.id = id
        self.title = title
        self.date = date
        self.emoji = emoji
    }
}

nonisolated enum SharedDataManager: Sendable {
    static func save(_ data: SharedWidgetData) {
        guard let shared = UserDefaults(suiteName: appGroupID) else { return }
        if let encoded = try? JSONEncoder().encode(data) {
            shared.set(encoded, forKey: "widgetData")
        }
    }

    static func load() -> SharedWidgetData {
        guard let shared = UserDefaults(suiteName: appGroupID),
              let data = shared.data(forKey: "widgetData"),
              let decoded = try? JSONDecoder().decode(SharedWidgetData.self, from: data) else {
            return SharedWidgetData()
        }
        return decoded
    }
}
