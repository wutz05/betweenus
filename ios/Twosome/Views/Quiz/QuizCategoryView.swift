import SwiftUI

struct QuizCategoryView: View {
    let category: QuizCategory
    @Environment(AppDataStore.self) private var store
    @State private var appeared: Bool = false
    @State private var selectedLevel: QuizLevel?

    private var levels: [QuizLevel] {
        QuizBank.levelsFor(category)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                categoryHeader
                    .padding(.bottom, 24)

                roadmapContent
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Theme.cream.ignoresSafeArea())
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedLevel) { level in
            QuizLevelView(level: level)
        }
        .onAppear {
            withAnimation(.spring(duration: 0.6)) {
                appeared = true
            }
        }
    }

    private var categoryHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(gradientForCategory)
                    .frame(width: 72, height: 72)
                    .shadow(color: categoryAccent.opacity(0.3), radius: 12, y: 4)

                Image(systemName: category.icon)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .symbolEffect(.bounce, value: appeared)
            }

            let progress = categoryProgress
            Text("\(Int(progress * 100))% Complete")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(categoryAccent)
        }
        .padding(.top, 8)
    }

    private var roadmapContent: some View {
        VStack(spacing: 0) {
            ForEach(Array(levels.enumerated()), id: \.element.id) { index, level in
                let completedCount = store.quizProgress.completedCountForLevel(level.id)
                let totalCount = level.questions.count
                let isCompleted = completedCount >= totalCount
                let isUnlocked = index == 0 || {
                    let prevLevel = levels[index - 1]
                    let prevDone = store.quizProgress.completedCountForLevel(prevLevel.id)
                    return prevDone >= prevLevel.questions.count
                }()

                VStack(spacing: 0) {
                    if index > 0 {
                        roadmapConnector(isCompleted: {
                            let prevLevel = levels[index - 1]
                            let prevDone = store.quizProgress.completedCountForLevel(prevLevel.id)
                            return prevDone >= prevLevel.questions.count
                        }())
                    }

                    roadmapNode(
                        level: level,
                        index: index,
                        completedCount: completedCount,
                        totalCount: totalCount,
                        isCompleted: isCompleted,
                        isUnlocked: isUnlocked
                    )
                }
            }
        }
    }

    private func roadmapConnector(isCompleted: Bool) -> some View {
        HStack {
            Spacer()
            Rectangle()
                .fill(isCompleted ? categoryAccent : Color(.systemGray4))
                .frame(width: 3, height: 32)
            Spacer()
        }
    }

    private func roadmapNode(level: QuizLevel, index: Int, completedCount: Int, totalCount: Int, isCompleted: Bool, isUnlocked: Bool) -> some View {
        Button {
            guard isUnlocked else { return }
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            selectedLevel = level
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(isCompleted ? categoryAccent.opacity(1) : (isUnlocked ? categoryAccent.opacity(0.15) : Color(.systemGray5)))
                        .frame(width: 48, height: 48)

                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                    } else if isUnlocked {
                        Text("\(level.levelNumber)")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(categoryAccent)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.subheadline)
                            .foregroundStyle(Color(.systemGray3))
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(level.title)
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(isUnlocked ? Theme.warmBrown : Theme.textTertiary)

                    if isUnlocked {
                        HStack(spacing: 4) {
                            ForEach(0..<totalCount, id: \.self) { qi in
                                Circle()
                                    .fill(qi < completedCount ? categoryAccent : Color(.systemGray4))
                                    .frame(width: 8, height: 8)
                            }
                            Spacer()
                            Text("\(completedCount)/\(totalCount)")
                                .font(.system(.caption2, design: .rounded, weight: .medium))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    } else {
                        Text("Complete previous level to unlock")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Theme.textTertiary)
                    }
                }

                Spacer()

                if isUnlocked && !isCompleted {
                    Image(systemName: "play.fill")
                        .font(.caption)
                        .foregroundStyle(categoryAccent)
                        .padding(8)
                        .background(categoryAccent.opacity(0.1), in: Circle())
                }
            }
            .padding(14)
            .background(
                isUnlocked ? Theme.cardBackground : Color(.systemGray6).opacity(0.5),
                in: .rect(cornerRadius: 18)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isCompleted ? categoryAccent.opacity(0.3) : Theme.cardBorder, lineWidth: 1)
            )
            .shadow(color: isUnlocked ? Theme.softShadow : .clear, radius: 6, y: 3)
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
        .animation(.spring(response: 0.5).delay(Double(index) * 0.06), value: appeared)
    }

    private var categoryAccent: Color {
        switch category {
        case .funny: Color(red: 1.0, green: 0.65, blue: 0.15)
        case .deep: Color(red: 0.3, green: 0.45, blue: 0.8)
        case .romantic: Theme.pink
        case .spicy: Color(red: 1.0, green: 0.25, blue: 0.15)
        }
    }

    private var gradientForCategory: LinearGradient {
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

    private var categoryProgress: Double {
        let total = levels.reduce(0) { $0 + $1.questions.count }
        guard total > 0 else { return 0 }
        let done = levels.reduce(0) { $0 + store.quizProgress.completedCountForLevel($1.id) }
        return Double(done) / Double(total)
    }
}
