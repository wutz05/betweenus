import Foundation

nonisolated enum QuizCategory: String, Codable, CaseIterable, Sendable, Identifiable, Hashable {
    case funny = "Funny"
    case deep = "Deep"
    case romantic = "Romantic"
    case spicy = "Spicy"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .funny: "face.smiling.inverse"
        case .deep: "brain.head.profile.fill"
        case .romantic: "heart.circle.fill"
        case .spicy: "flame.fill"
        }
    }

}

nonisolated struct QuizLevel: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let category: QuizCategory
    let levelNumber: Int
    let title: String
    let questions: [QuizQuestion]

    init(category: QuizCategory, levelNumber: Int, title: String, questions: [QuizQuestion]) {
        self.id = "\(category.rawValue)-\(levelNumber)"
        self.category = category
        self.levelNumber = levelNumber
        self.title = title
        self.questions = questions
    }
}

nonisolated struct QuizQuestion: Codable, Identifiable, Sendable, Hashable {
    let id: String
    let text: String

    init(text: String) {
        self.id = text.hashValue.description
        self.text = text
    }
}

nonisolated struct QuizProgress: Codable, Sendable {
    var completedQuestions: [String: [String]]

    init() {
        self.completedQuestions = [:]
    }

    func isQuestionCompleted(levelId: String, questionId: String) -> Bool {
        completedQuestions[levelId]?.contains(questionId) ?? false
    }

    func completedCountForLevel(_ levelId: String) -> Int {
        completedQuestions[levelId]?.count ?? 0
    }

    mutating func markCompleted(levelId: String, questionId: String) {
        var list = completedQuestions[levelId] ?? []
        if !list.contains(questionId) {
            list.append(questionId)
        }
        completedQuestions[levelId] = list
    }
}
