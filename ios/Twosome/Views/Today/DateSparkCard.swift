import SwiftUI

struct DateSparkCard: View {
    @Environment(AppDataStore.self) private var store
    @State private var showConfetti = false
    @State private var showIdea = false
    @State private var ideaAppeared = false

    private var spark: DateSparkIdea { store.todaySpark }
    private var response: DateSparkResponse? { store.todaySparkResponse }
    private var hasResponded: Bool { response?.myResponse != nil }

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "lightbulb.fill")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.9))
                    Text("Date Ideas")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.9))
                    Spacer()
                    if showIdea || hasResponded {
                        Text(spark.emoji)
                            .font(.title2)
                            .transition(.scale.combined(with: .opacity))
                    }
                }

                if hasResponded {
                    respondedContent
                } else if showIdea {
                    ideaContent
                } else {
                    promptContent
                }
            }
            .padding(18)
            .background(
                LinearGradient(
                    colors: [Theme.coral, Theme.pink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(.rect(cornerRadius: 22))
            )
            .shadow(color: Theme.coral.opacity(0.3), radius: 12, y: 6)

            if showConfetti {
                ConfettiView()
            }
        }
    }

    private var promptContent: some View {
        VStack(spacing: 16) {
            Text("Ready for a date idea?")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            Text("Tap below to get a fun date suggestion for you two")
                .font(.system(.subheadline, design: .serif))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showIdea = true
                }
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.15)) {
                    ideaAppeared = true
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.subheadline)
                    Text("Get a Date Idea")
                        .font(.system(.subheadline, design: .rounded, weight: .bold))
                }
                .foregroundStyle(Theme.coral)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(.white, in: Capsule())
            }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: showIdea)
        }
    }

    private var ideaContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(spark.title)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(.white)

                Text(spark.description)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundStyle(.white.opacity(0.85))
                    .lineLimit(2)
            }
            .opacity(ideaAppeared ? 1 : 0)
            .offset(y: ideaAppeared ? 0 : 10)

            HStack(spacing: 12) {
                Button {
                    store.respondToDateSpark(accepted: false)
                } label: {
                    Text("Skip")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(.white.opacity(0.2), in: Capsule())
                }

                Button {
                    store.respondToDateSpark(accepted: true)
                    showConfetti = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                        Text("We're in!")
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.coral)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(.white, in: Capsule())
                }
                .sensoryFeedback(.success, trigger: showConfetti)
            }
            .opacity(ideaAppeared ? 1 : 0)
            .offset(y: ideaAppeared ? 0 : 10)
        }
    }

    private var respondedContent: some View {
        HStack {
            Image(systemName: response?.myResponse == true ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(.white)
            Text(response?.myResponse == true ? "You're in!" : "Skipped")
                .font(.system(.caption, design: .rounded, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.white.opacity(0.2), in: Capsule())
    }
}
