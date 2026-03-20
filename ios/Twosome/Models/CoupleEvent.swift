import Foundation

nonisolated struct CoupleEvent: Codable, Identifiable, Sendable, Hashable {
    let id: UUID
    var title: String
    var date: Date
    var emoji: String
    var type: EventType
    var note: String?
    var isRecurring: Bool

    init(id: UUID = UUID(), title: String, date: Date, emoji: String, type: EventType, note: String? = nil, isRecurring: Bool = false) {
        self.id = id
        self.title = title
        self.date = date
        self.emoji = emoji
        self.type = type
        self.note = note
        self.isRecurring = isRecurring
    }

    nonisolated enum EventType: String, Codable, Sendable, Hashable {
        case anniversary
        case monthlyAnniversary
        case birthday
        case holiday
        case dateSpark
        case custom
    }
}

nonisolated struct CouplePhoto: Codable, Identifiable, Sendable {
    let id: UUID
    let date: Date
    let imageData: Data

    init(date: Date = Date(), imageData: Data) {
        self.id = UUID()
        self.date = date
        self.imageData = imageData
    }
}
