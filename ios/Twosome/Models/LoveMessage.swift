import Foundation

nonisolated struct LoveMessage: Codable, Identifiable, Sendable {
    let id: UUID
    let text: String
    let senderName: String
    let date: Date

    init(text: String, senderName: String, date: Date) {
        self.id = UUID()
        self.text = text
        self.senderName = senderName
        self.date = date
    }
}
