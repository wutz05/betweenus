import SwiftUI

struct DailyQuestionCard: View {
    @Environment(AppDataStore.self) private var store
    let onTap: () -> Void

    var body: some View {
        Button {
            onTap()
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.subheadline)
                        .foregroundStyle(Theme.coral)
                    Text("Daily Question")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundStyle(Theme.textTertiary)
                }

                Text(store.todayQuestion)
                    .font(.system(.body, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.warmBrown)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)

                HStack(spacing: 12) {
                    answerPill(
                        name: store.coupleData.me.name,
                        answered: store.todayAnswer?.myAnswer != nil
                    )
                    answerPill(
                        name: store.coupleData.partner.name,
                        answered: store.todayAnswer?.partnerAnswer != nil
                    )
                }
            }
            .padding(16)
            .background(Theme.cardBackground, in: .rect(cornerRadius: 22))
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Theme.cardBorder, lineWidth: 1)
            )
            .shadow(color: Theme.softShadow, radius: 8, y: 4)
        }
        .buttonStyle(.plain)
    }

    private func answerPill(name: String, answered: Bool) -> some View {
        HStack(spacing: 4) {
            if answered {
                Image(systemName: "checkmark.circle.fill")
                    .font(.caption2)
                    .foregroundStyle(.green)
            }
            Text(answered ? "Answered ✓" : "Waiting...")
                .font(.system(.caption2, design: .rounded, weight: .medium))
                .foregroundStyle(answered ? .green : Theme.textSecondary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            answered ? Color.green.opacity(0.1) : Color(.tertiarySystemFill),
            in: Capsule()
        )
    }
}

struct DailyQuestionSheet: View {
    @Environment(AppDataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var answer: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 16) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(Theme.coral)

                        Text(store.todayQuestion)
                            .font(.system(.title3, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.warmBrown)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 16)

                    if let existingAnswer = store.todayAnswer, let myAnswer = existingAnswer.myAnswer {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Your answer")
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary)
                            Text(myAnswer)
                                .font(.body)
                                .foregroundStyle(Theme.warmBrown)
                                .padding(14)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Theme.lightCoral, in: .rect(cornerRadius: 12))
                        }

                        if let partnerAnswer = existingAnswer.partnerAnswer {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("\(store.coupleData.partner.name)'s answer")
                                    .font(.system(.caption, design: .rounded, weight: .semibold))
                                    .foregroundStyle(Theme.textSecondary)
                                Text(partnerAnswer)
                                    .font(.body)
                                    .foregroundStyle(Theme.warmBrown)
                                    .padding(14)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color(.tertiarySystemFill), in: .rect(cornerRadius: 12))
                            }
                        } else {
                            HStack {
                                Image(systemName: "hourglass")
                                    .foregroundStyle(Theme.textSecondary)
                                Text("Waiting for \(store.coupleData.partner.name) to answer...")
                                    .font(.subheadline)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.tertiarySystemFill), in: .rect(cornerRadius: 12))
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Your answer")
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                .foregroundStyle(Theme.textSecondary)
                            TextField("Type your answer...", text: $answer, axis: .vertical)
                                .font(.body)
                                .foregroundStyle(Color(.label))
                                .lineLimit(4...8)
                                .padding(14)
                                .background(Color(.tertiarySystemFill), in: .rect(cornerRadius: 12))
                        }

                        Button {
                            store.answerDailyQuestion(answer)
                            dismiss()
                        } label: {
                            Text("Submit Answer")
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    answer.trimmingCharacters(in: .whitespaces).isEmpty ? Theme.coral.opacity(0.4) : Theme.coral,
                                    in: .rect(cornerRadius: 14)
                                )
                        }
                        .disabled(answer.trimmingCharacters(in: .whitespaces).isEmpty)
                    }
                }
                .padding(20)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Daily Question")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.coral)
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationContentInteraction(.scrolls)
    }
}
