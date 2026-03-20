import SwiftUI
import WidgetKit

@Observable
@MainActor
class AppDataStore {
    var coupleData: CoupleData
    var events: [CoupleEvent]
    var photos: [CouplePhoto]
    var dailyAnswers: [DailyAnswer]
    var dateSparkResponses: [DateSparkResponse]
    var widgetConfig: WidgetConfig
    var wishlistItems: [WishlistItem]
    var hasCompletedOnboarding: Bool
    var selectedMascot: MascotType
    var messages: [LoveMessage]
    var quizProgress: QuizProgress

    init() {
        self.coupleData = CoupleData()
        self.events = []
        self.photos = []
        self.dailyAnswers = []
        self.dateSparkResponses = []
        self.widgetConfig = WidgetConfig()
        self.wishlistItems = []
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        self.selectedMascot = .bears
        self.messages = []
        self.quizProgress = QuizProgress()
        loadData()
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        default: return "Good evening"
        }
    }

    var timeTogetherString: String {
        guard let anniversary = coupleData.anniversaryDate else { return "" }
        let components = Calendar.current.dateComponents([.year, .month], from: anniversary, to: Date())
        let years = components.year ?? 0
        let months = components.month ?? 0
        if years > 0 {
            return "together \(years) year\(years == 1 ? "" : "s"), \(months) month\(months == 1 ? "" : "s")"
        } else {
            return "together \(months) month\(months == 1 ? "" : "s")"
        }
    }

    var daysTogether: Int {
        guard let anniversary = coupleData.anniversaryDate else { return 0 }
        return Calendar.current.dateComponents([.day], from: anniversary, to: Date()).day ?? 0
    }

    var nextAnniversary: Date? {
        guard let anniversary = coupleData.anniversaryDate else { return nil }
        let now = Date()
        let cal = Calendar.current
        var components = cal.dateComponents([.month, .day], from: anniversary)
        components.year = cal.component(.year, from: now)
        guard let thisYear = cal.date(from: components) else { return nil }
        if thisYear > now {
            return thisYear
        }
        components.year = cal.component(.year, from: now) + 1
        return cal.date(from: components)
    }

    var daysUntilNextAnniversary: Int? {
        guard let next = nextAnniversary else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: next).day
    }

    var todayQuestion: String {
        QuestionsBank.questionForDate(Date())
    }

    var todayQuestionIndex: Int {
        QuestionsBank.indexForDate(Date())
    }

    var todayAnswer: DailyAnswer? {
        let cal = Calendar.current
        return dailyAnswers.first { cal.isDateInToday($0.date) }
    }

    var todaySpark: DateSparkIdea {
        DateSparksBank.sparkForDate(Date())
    }

    var todaySparkIndex: Int {
        DateSparksBank.indexForDate(Date())
    }

    var todaySparkResponse: DateSparkResponse? {
        let cal = Calendar.current
        return dateSparkResponses.first { cal.isDateInToday($0.date) }
    }

    var memoryPhoto: CouplePhoto? {
        let cal = Calendar.current
        let oneYearAgo = cal.date(byAdding: .year, value: -1, to: Date()) ?? Date()
        return photos.min(by: { abs($0.date.timeIntervalSince(oneYearAgo)) < abs($1.date.timeIntervalSince(oneYearAgo)) })
    }

    func generateInviteCode() -> String {
        let chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
        return String((0..<6).map { _ in chars.randomElement()! })
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
        coupleData.isConnected = true
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        generateDefaultEvents()
        saveData()
    }

    func answerDailyQuestion(_ answer: String) {
        if var existing = todayAnswer {
            existing.myAnswer = answer
            if let idx = dailyAnswers.firstIndex(where: { $0.id == existing.id }) {
                dailyAnswers[idx] = existing
            }
        } else {
            var newAnswer = DailyAnswer(questionIndex: todayQuestionIndex, date: Date())
            newAnswer.myAnswer = answer
            dailyAnswers.append(newAnswer)
        }
        coupleData.questionsAnswered += 1
        updateStreak()
        saveData()
    }

    func respondToDateSpark(accepted: Bool) {
        if var existing = todaySparkResponse {
            existing.myResponse = accepted
            if let idx = dateSparkResponses.firstIndex(where: { $0.id == existing.id }) {
                dateSparkResponses[idx] = existing
            }
        } else {
            var newResponse = DateSparkResponse(sparkIndex: todaySparkIndex, date: Date())
            newResponse.myResponse = accepted
            dateSparkResponses.append(newResponse)
        }
        if accepted {
            coupleData.dateSparksAccepted += 1
        }
        saveData()
    }

    func addPhoto(_ imageData: Data) {
        let photo = CouplePhoto(imageData: imageData)
        photos.append(photo)
        saveData()
    }

    func addCustomEvent(_ event: CoupleEvent) {
        events.append(event)
        saveData()
    }

    func addWishlistItem(_ item: WishlistItem) {
        wishlistItems.append(item)
        saveData()
    }

    func toggleWishlistItem(_ item: WishlistItem) {
        if let idx = wishlistItems.firstIndex(where: { $0.id == item.id }) {
            wishlistItems[idx].isCompleted.toggle()
            saveData()
        }
    }

    func deleteWishlistItem(_ item: WishlistItem) {
        wishlistItems.removeAll { $0.id == item.id }
        saveData()
    }

    func setMascot(_ mascot: MascotType) {
        selectedMascot = mascot
        saveData()
    }

    func completeQuizQuestion(levelId: String, questionId: String) {
        quizProgress.markCompleted(levelId: levelId, questionId: questionId)
        saveData()
    }

    func sendMessage(_ text: String) {
        let message = LoveMessage(text: text, senderName: coupleData.me.name, date: Date())
        messages.append(message)
        saveData()
    }

    func eventsForDate(_ date: Date) -> [CoupleEvent] {
        let cal = Calendar.current
        return events.filter { event in
            if event.isRecurring {
                let eventMonth = cal.component(.month, from: event.date)
                let eventDay = cal.component(.day, from: event.date)
                let dateMonth = cal.component(.month, from: date)
                let dateDay = cal.component(.day, from: date)
                return eventMonth == dateMonth && eventDay == dateDay
            }
            return cal.isDate(event.date, inSameDayAs: date)
        }
    }

    func hasEventsOnDate(_ date: Date) -> Bool {
        !eventsForDate(date).isEmpty
    }

    private func updateStreak() {
        coupleData.lastOpenedByMe = Date()
        coupleData.streakCount += 1
        if coupleData.streakCount > coupleData.streakRecord {
            coupleData.streakRecord = coupleData.streakCount
        }
    }

    private func generateDefaultEvents() {
        var newEvents: [CoupleEvent] = []

        if let anniversary = coupleData.anniversaryDate {
            newEvents.append(CoupleEvent(title: "Our Anniversary ❤️", date: anniversary, emoji: "💍", type: .anniversary, isRecurring: true))

            for month in 1...11 {
                if let monthlyDate = Calendar.current.date(byAdding: .month, value: month, to: anniversary) {
                    newEvents.append(CoupleEvent(title: "\(month)-month anniversary", date: monthlyDate, emoji: "💕", type: .monthlyAnniversary, isRecurring: true))
                }
            }
        }

        if let myBirthday = coupleData.me.birthday {
            newEvents.append(CoupleEvent(title: "\(coupleData.me.name)'s Birthday", date: myBirthday, emoji: "🎂", type: .birthday, isRecurring: true))
        }

        if let partnerBirthday = coupleData.partner.birthday {
            newEvents.append(CoupleEvent(title: "\(coupleData.partner.name)'s Birthday", date: partnerBirthday, emoji: "🎂", type: .birthday, isRecurring: true))
        }

        let cal = Calendar.current
        let year = cal.component(.year, from: Date())

        let holidays: [(String, Int, Int, String)] = [
            ("Valentine's Day", 2, 14, "❤️"),
            ("Women's Day", 3, 8, "🌷"),
            ("Christmas Eve", 12, 24, "🎄"),
            ("Christmas Day", 12, 25, "🎁"),
            ("New Year's Eve", 12, 31, "🎆"),
            ("New Year's Day", 1, 1, "🥂"),
        ]

        for (name, month, day, emoji) in holidays {
            var comps = DateComponents()
            comps.year = year
            comps.month = month
            comps.day = day
            if let date = cal.date(from: comps) {
                newEvents.append(CoupleEvent(title: name, date: date, emoji: emoji, type: .holiday, isRecurring: true))
            }
        }

        events = newEvents
    }

    func syncWidgetData() {
        var widgetData = SharedWidgetData()
        widgetData.myName = coupleData.me.name
        widgetData.partnerName = coupleData.partner.name
        widgetData.anniversaryDate = coupleData.anniversaryDate
        widgetData.distanceKm = coupleData.distanceKm

        if let lastMessage = messages.last {
            widgetData.latestMessage = lastMessage.text
            widgetData.latestMessageSender = lastMessage.senderName
            widgetData.latestMessageDate = lastMessage.date
        }

        let cal = Calendar.current
        let now = Date()
        let futureLimit = cal.date(byAdding: .month, value: 6, to: now) ?? now
        var upcoming: [SharedEvent] = []

        for event in events {
            if event.isRecurring {
                let eventMonth = cal.component(.month, from: event.date)
                let eventDay = cal.component(.day, from: event.date)
                var comps = DateComponents()
                comps.year = cal.component(.year, from: now)
                comps.month = eventMonth
                comps.day = eventDay
                if let thisYear = cal.date(from: comps) {
                    if thisYear >= cal.startOfDay(for: now) && thisYear <= futureLimit {
                        upcoming.append(SharedEvent(title: event.title, date: thisYear, emoji: event.emoji))
                    } else if thisYear < cal.startOfDay(for: now) {
                        comps.year = cal.component(.year, from: now) + 1
                        if let nextYear = cal.date(from: comps), nextYear <= futureLimit {
                            upcoming.append(SharedEvent(title: event.title, date: nextYear, emoji: event.emoji))
                        }
                    }
                }
            } else if event.date >= cal.startOfDay(for: now) && event.date <= futureLimit {
                upcoming.append(SharedEvent(title: event.title, date: event.date, emoji: event.emoji))
            }
        }

        widgetData.upcomingEvents = upcoming.sorted { $0.date < $1.date }
        SharedDataManager.save(widgetData)
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func saveData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(coupleData) {
            UserDefaults.standard.set(data, forKey: "coupleData")
        }
        if let data = try? encoder.encode(events) {
            UserDefaults.standard.set(data, forKey: "events")
        }
        if let data = try? encoder.encode(dailyAnswers) {
            UserDefaults.standard.set(data, forKey: "dailyAnswers")
        }
        if let data = try? encoder.encode(dateSparkResponses) {
            UserDefaults.standard.set(data, forKey: "dateSparkResponses")
        }
        if let data = try? encoder.encode(widgetConfig) {
            UserDefaults.standard.set(data, forKey: "widgetConfig")
        }
        if let data = try? encoder.encode(wishlistItems) {
            UserDefaults.standard.set(data, forKey: "wishlistItems")
        }
        if let data = try? encoder.encode(photos) {
            UserDefaults.standard.set(data, forKey: "photos")
        }
        UserDefaults.standard.set(selectedMascot.rawValue, forKey: "selectedMascot")
        if let data = try? encoder.encode(messages) {
            UserDefaults.standard.set(data, forKey: "messages")
        }
        if let data = try? encoder.encode(quizProgress) {
            UserDefaults.standard.set(data, forKey: "quizProgress")
        }
        syncWidgetData()
    }

    private func loadData() {
        let decoder = JSONDecoder()
        if let data = UserDefaults.standard.data(forKey: "coupleData"),
           let decoded = try? decoder.decode(CoupleData.self, from: data) {
            coupleData = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "events"),
           let decoded = try? decoder.decode([CoupleEvent].self, from: data) {
            events = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "dailyAnswers"),
           let decoded = try? decoder.decode([DailyAnswer].self, from: data) {
            dailyAnswers = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "dateSparkResponses"),
           let decoded = try? decoder.decode([DateSparkResponse].self, from: data) {
            dateSparkResponses = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "widgetConfig"),
           let decoded = try? decoder.decode(WidgetConfig.self, from: data) {
            widgetConfig = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "wishlistItems"),
           let decoded = try? decoder.decode([WishlistItem].self, from: data) {
            wishlistItems = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "photos"),
           let decoded = try? decoder.decode([CouplePhoto].self, from: data) {
            photos = decoded
        }
        if let raw = UserDefaults.standard.string(forKey: "selectedMascot"),
           let mascot = MascotType(rawValue: raw) {
            selectedMascot = mascot
        }
        if let data = UserDefaults.standard.data(forKey: "messages"),
           let decoded = try? decoder.decode([LoveMessage].self, from: data) {
            messages = decoded
        }
        if let data = UserDefaults.standard.data(forKey: "quizProgress"),
           let decoded = try? decoder.decode(QuizProgress.self, from: data) {
            quizProgress = decoded
        }
    }
}
