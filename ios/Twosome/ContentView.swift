import SwiftUI

struct ContentView: View {
    @Environment(AppDataStore.self) private var store
    @State private var selectedTab: Int = 0

    var body: some View {
        if store.hasCompletedOnboarding {
            TabView(selection: $selectedTab) {
                Tab("Today", systemImage: "heart.fill", value: 0) {
                    TodayView()
                }
                Tab("Calendar", systemImage: "calendar", value: 1) {
                    CoupleCalendarView()
                }
                Tab("Quiz", systemImage: "gamecontroller.fill", value: 2) {
                    QuizView()
                }
                Tab("Profile", systemImage: "person.2.fill", value: 3) {
                    ProfileView()
                }
            }
            .tint(Theme.coral)
        } else {
            OnboardingView()
        }
    }
}
