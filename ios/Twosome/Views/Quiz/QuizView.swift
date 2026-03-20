import SwiftUI

struct QuizView: View {
    @Environment(AppDataStore.self) private var store
    @State private var appeared: Bool = false
    @State private var selectedCategory: QuizCategory?

    private var totalQuestions: Int {
        QuizBank.levels.reduce(0) { $0 + $1.questions.count }
    }

    private var completedQuestions: Int {
        var count = 0
        for level in QuizBank.levels {
            count += store.quizProgress.completedCountForLevel(level.id)
        }
        return count
    }

    private var overallProgress: Double {
        guard totalQuestions > 0 else { return 0 }
        return Double(completedQuestions) / Double(totalQuestions)
    }

    private var overallLevel: Int {
        max(1, Int(overallProgress * 100) / 5 + 1)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    overallProgressCard
                    categoriesGrid
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Quiz")
            .navigationDestination(item: $selectedCategory) { category in
                QuizCategoryView(category: category)
            }
        }
    }

    private var overallProgressCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Theme.coral.opacity(0.15), lineWidth: 10)
                    .frame(width: 120, height: 120)

                Circle()
                    .trim(from: 0, to: appeared ? overallProgress : 0)
                    .stroke(
                        AngularGradient(
                            colors: [Theme.coral, Theme.pink, Theme.coral],
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(duration: 1.2, bounce: 0.2), value: appeared)

                VStack(spacing: 2) {
                    Text("Lvl \(overallLevel)")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(Theme.warmBrown)
                    Text("\(Int(overallProgress * 100))%")
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(Theme.coral)
                }
            }

            VStack(spacing: 4) {
                Text("Your Couple Journey")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.warmBrown)
                Text("\(completedQuestions) of \(totalQuestions) questions answered")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding(.vertical, 24)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground, in: .rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 8, y: 4)
        .onAppear {
            withAnimation {
                appeared = true
            }
        }
    }

    private var categoriesGrid: some View {
        VStack(spacing: 14) {
            ForEach(Array(QuizCategory.allCases.enumerated()), id: \.element.id) { index, category in
                categoryCard(category: category, index: index)
            }
        }
    }

    private func categoryProgress(_ category: QuizCategory) -> Double {
        let levels = QuizBank.levelsFor(category)
        let total = levels.reduce(0) { $0 + $1.questions.count }
        guard total > 0 else { return 0 }
        let done = levels.reduce(0) { $0 + store.quizProgress.completedCountForLevel($1.id) }
        return Double(done) / Double(total)
    }

    private func categoryCard(category: QuizCategory, index: Int) -> some View {
        let progress = categoryProgress(category)

        return Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            selectedCategory = category
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(gradientForCategory(category))
                        .frame(width: 52, height: 52)
                    Image(systemName: category.icon)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(category.rawValue)
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Theme.warmBrown)

                    HStack(spacing: 6) {
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color(.systemGray5))
                                    .frame(height: 6)
                                Capsule()
                                    .fill(gradientForCategory(category))
                                    .frame(width: max(0, geo.size.width * progress), height: 6)
                                    .animation(.spring(duration: 0.8).delay(Double(index) * 0.1), value: appeared)
                            }
                        }
                        .frame(height: 6)

                        Text("\(Int(progress * 100))%")
                            .font(.system(.caption2, design: .rounded, weight: .semibold))
                            .foregroundStyle(Theme.textSecondary)
                            .frame(width: 32, alignment: .trailing)
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(14)
            .background(Theme.cardBackground, in: .rect(cornerRadius: 18))
            .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.cardBorder, lineWidth: 1))
            .shadow(color: Theme.softShadow, radius: 6, y: 3)
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(response: 0.5).delay(Double(index) * 0.08), value: appeared)
    }

    private func gradientForCategory(_ category: QuizCategory) -> LinearGradient {
        switch category {
        case .funny:
            LinearGradient(colors: [Color(red: 1.0, green: 0.75, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .deep:
            LinearGradient(colors: [Color(red: 0.35, green: 0.5, blue: 0.85), Color(red: 0.25, green: 0.35, blue: 0.75)], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .romantic:
            LinearGradient(colors: [Theme.pink, Theme.coral], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .spicy:
            LinearGradient(colors: [Color(red: 1.0, green: 0.3, blue: 0.2), Color(red: 0.85, green: 0.15, blue: 0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
