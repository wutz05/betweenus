import SwiftUI

struct TodayView: View {
    @Environment(AppDataStore.self) private var store
    @State private var showQuestionSheet = false
    @State private var showMessageOverlay = false
    @State private var showCustomizeSheet = false
    @State private var appeared = false

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        headerSection
                        mascotSection
                        actionButtons
                        cardsSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .background(Theme.cream.ignoresSafeArea())
                .navigationBarTitleDisplayMode(.inline)

                if showMessageOverlay {
                    SendMessageOverlay(isPresented: $showMessageOverlay)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: showMessageOverlay)
        }
        .sheet(isPresented: $showQuestionSheet) {
            DailyQuestionSheet()
        }
        .sheet(isPresented: $showCustomizeSheet) {
            CustomizeSheet()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
        }
    }

    private var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(store.greeting),")
                    .font(.system(.title3, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
                Text(store.coupleData.me.name.isEmpty ? "Love" : store.coupleData.me.name)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)
            }
            Spacer()
            StreakPill(count: store.coupleData.streakCount)
        }
        .padding(.top, 8)
    }

    private var mascotSection: some View {
        VStack(spacing: 8) {
            if let mascotImage = UIImage(named: store.selectedMascot.imageName) {
                Image(uiImage: mascotImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 160)
            } else {
                Image(systemName: "heart.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(Theme.coral)
                    .padding(.vertical, 20)
            }

            Text("\(store.coupleData.me.name) & \(store.coupleData.partner.name)")
                .font(.system(.title3, design: .serif, weight: .semibold))
                .foregroundStyle(Theme.warmBrown)

            if !store.timeTogetherString.isEmpty {
                Text(store.timeTogetherString)
                    .font(.system(.caption, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding(.vertical, 8)
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
                    showMessageOverlay = true
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "envelope.heart.fill")
                        .font(.subheadline)
                    Text("Send a Note")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 13)
                .background(
                    LinearGradient(colors: [Theme.coral, Theme.pink], startPoint: .leading, endPoint: .trailing),
                    in: Capsule()
                )
                .shadow(color: Theme.coral.opacity(0.3), radius: 8, y: 4)
            }
            .sensoryFeedback(.impact(flexibility: .soft), trigger: showMessageOverlay)

            Button {
                showCustomizeSheet = true
            } label: {
                Image(systemName: "paintbrush.fill")
                    .font(.subheadline)
                    .foregroundStyle(Theme.coral)
                    .frame(width: 46, height: 46)
                    .background(Theme.cardBackground, in: Circle())
                    .overlay(Circle().stroke(Theme.cardBorder, lineWidth: 1))
                    .shadow(color: Theme.softShadow, radius: 6, y: 3)
            }
        }
    }

    @ViewBuilder
    private var cardsSection: some View {
        if store.widgetConfig.showDailyQuestion {
            DailyQuestionCard(onTap: { showQuestionSheet = true })
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
        }

        if store.widgetConfig.showDateSpark {
            DateSparkCard()
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
        }

        if store.widgetConfig.showMemoryFlash {
            MemoryFlashCard()
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
        }

        if store.widgetConfig.showCountdown, let days = store.daysUntilNextAnniversary {
            CountdownCard(daysUntil: days)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
        }

        if store.widgetConfig.showDaysTogether {
            DaysTogetherCard(days: store.daysTogether)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
        }
    }
}
