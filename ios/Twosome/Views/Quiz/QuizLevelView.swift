import SwiftUI

struct QuizLevelView: View {
    let level: QuizLevel
    @Environment(AppDataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int = 0
    @State private var myAnswer: String = ""
    @State private var showingCompletion: Bool = false
    @State private var cardOffset: CGFloat = 0
    @State private var cardOpacity: Double = 1

    private var currentQuestion: QuizQuestion? {
        guard currentIndex < level.questions.count else { return nil }
        return level.questions[currentIndex]
    }

    private var isCurrentAnswered: Bool {
        guard let q = currentQuestion else { return false }
        return store.quizProgress.isQuestionCompleted(levelId: level.id, questionId: q.id)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.cream.ignoresSafeArea()

                if showingCompletion {
                    completionView
                        .transition(.scale.combined(with: .opacity))
                } else {
                    questionContent
                }
            }
            .navigationTitle(level.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(Theme.textTertiary)
                    }
                }
            }
        }
    }

    private var questionContent: some View {
        VStack(spacing: 24) {
            progressDots

            Spacer()

            if let question = currentQuestion {
                questionCard(question)
                    .offset(x: cardOffset)
                    .opacity(cardOpacity)
            }

            Spacer()

            if !isCurrentAnswered {
                answerSection
            } else {
                answeredState
            }

            navigationButtons
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private var progressDots: some View {
        HStack(spacing: 6) {
            ForEach(0..<level.questions.count, id: \.self) { i in
                let q = level.questions[i]
                let done = store.quizProgress.isQuestionCompleted(levelId: level.id, questionId: q.id)
                Circle()
                    .fill(i == currentIndex ? categoryAccent : (done ? categoryAccent.opacity(0.4) : Color(.systemGray4)))
                    .frame(width: i == currentIndex ? 10 : 8, height: i == currentIndex ? 10 : 8)
                    .animation(.spring(response: 0.3), value: currentIndex)
            }
        }
        .padding(.top, 12)
    }

    private func questionCard(_ question: QuizQuestion) -> some View {
        VStack(spacing: 20) {
            Image(systemName: level.category.icon)
                .font(.system(size: 36))
                .foregroundStyle(categoryAccent)
                .symbolEffect(.pulse)

            Text(question.text)
                .font(.system(.title3, design: .serif, weight: .medium))
                .italic()
                .foregroundStyle(Theme.warmBrown)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 8)

            Text("Question \(currentIndex + 1) of \(level.questions.count)")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Theme.textTertiary)
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .background(Theme.cardBackground, in: .rect(cornerRadius: 24))
        .overlay(RoundedRectangle(cornerRadius: 24).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 10, y: 5)
    }

    private var answerSection: some View {
        VStack(spacing: 12) {
            TextField("Share your answer...", text: $myAnswer, axis: .vertical)
                .font(.system(.body, design: .rounded))
                .padding(14)
                .background(Theme.cardBackground, in: .rect(cornerRadius: 14))
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
                .lineLimit(3...6)

            Button {
                guard let q = currentQuestion, !myAnswer.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                store.completeQuizQuestion(levelId: level.id, questionId: q.id)
                myAnswer = ""

                let allDone = level.questions.allSatisfy {
                    store.quizProgress.isQuestionCompleted(levelId: level.id, questionId: $0.id)
                }
                if allDone {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        showingCompletion = true
                    }
                }
            } label: {
                Text("Submit Answer")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(categoryAccent, in: .rect(cornerRadius: 14))
            }
            .disabled(myAnswer.trimmingCharacters(in: .whitespaces).isEmpty)
            .opacity(myAnswer.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
        }
    }

    private var answeredState: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
            Text("Answered")
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(Color.green.opacity(0.08), in: .rect(cornerRadius: 14))
    }

    private var navigationButtons: some View {
        HStack(spacing: 12) {
            Button {
                navigateTo(currentIndex - 1)
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(currentIndex > 0 ? categoryAccent : Theme.textTertiary)
                    .frame(width: 48, height: 48)
                    .background(Theme.cardBackground, in: Circle())
                    .overlay(Circle().stroke(Theme.cardBorder, lineWidth: 1))
            }
            .disabled(currentIndex == 0)

            Spacer()

            Button {
                if currentIndex < level.questions.count - 1 {
                    navigateTo(currentIndex + 1)
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(currentIndex < level.questions.count - 1 ? categoryAccent : Theme.textTertiary)
                    .frame(width: 48, height: 48)
                    .background(Theme.cardBackground, in: Circle())
                    .overlay(Circle().stroke(Theme.cardBorder, lineWidth: 1))
            }
            .disabled(currentIndex >= level.questions.count - 1)
        }
    }

    private func navigateTo(_ index: Int) {
        guard index >= 0, index < level.questions.count else { return }
        UISelectionFeedbackGenerator().selectionChanged()

        let direction: CGFloat = index > currentIndex ? -1 : 1
        withAnimation(.easeIn(duration: 0.15)) {
            cardOffset = direction * 300
            cardOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            currentIndex = index
            myAnswer = ""
            cardOffset = -direction * 300

            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                cardOffset = 0
                cardOpacity = 1
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "trophy.fill")
                .font(.system(size: 64))
                .foregroundStyle(categoryAccent)
                .symbolEffect(.bounce, value: showingCompletion)

            Text("Level Complete!")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Theme.warmBrown)

            Text("You finished \"\(level.title)\"")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Theme.textSecondary)

            Spacer()

            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                dismiss()
            } label: {
                Text("Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(categoryAccent, in: .rect(cornerRadius: 16))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
    }

    private var categoryAccent: Color {
        switch level.category {
        case .funny: Color(red: 1.0, green: 0.65, blue: 0.15)
        case .deep: Color(red: 0.3, green: 0.45, blue: 0.8)
        case .romantic: Theme.pink
        case .spicy: Color(red: 1.0, green: 0.25, blue: 0.15)
        }
    }
}
