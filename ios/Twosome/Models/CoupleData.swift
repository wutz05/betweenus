import Foundation

nonisolated struct Partner: Codable, Identifiable, Sendable {
    let id: UUID
    var name: String
    var birthday: Date?
    var photoData: Data?

    init(id: UUID = UUID(), name: String = "", birthday: Date? = nil, photoData: Data? = nil) {
        self.id = id
        self.name = name
        self.birthday = birthday
        self.photoData = photoData
    }
}

nonisolated struct CoupleData: Codable, Sendable {
    var me: Partner
    var partner: Partner
    var anniversaryDate: Date?
    var inviteCode: String
    var isConnected: Bool
    var streakCount: Int
    var streakRecord: Int
    var lastOpenedByMe: Date?
    var lastOpenedByPartner: Date?
    var questionsAnswered: Int
    var dateSparksAccepted: Int
    var distanceKm: Int?

    init() {
        self.me = Partner()
        self.partner = Partner()
        self.anniversaryDate = nil
        self.inviteCode = ""
        self.isConnected = false
        self.streakCount = 0
        self.streakRecord = 0
        self.lastOpenedByMe = nil
        self.lastOpenedByPartner = nil
        self.questionsAnswered = 0
        self.dateSparksAccepted = 0
        self.distanceKm = nil
    }
}

nonisolated struct DailyAnswer: Codable, Identifiable, Sendable {
    let id: UUID
    let questionIndex: Int
    let date: Date
    var myAnswer: String?
    var partnerAnswer: String?

    init(questionIndex: Int, date: Date) {
        self.id = UUID()
        self.questionIndex = questionIndex
        self.date = date
    }
}

nonisolated struct DateSparkResponse: Codable, Identifiable, Sendable {
    let id: UUID
    let sparkIndex: Int
    let date: Date
    var myResponse: Bool?
    var partnerResponse: Bool?

    init(sparkIndex: Int, date: Date) {
        self.id = UUID()
        self.sparkIndex = sparkIndex
        self.date = date
    }

    var bothAccepted: Bool {
        myResponse == true && partnerResponse == true
    }
}
