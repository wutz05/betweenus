import SwiftUI

nonisolated enum SubscriptionPlan: String, Identifiable, Sendable {
    case monthly
    case sixMonths

    var id: String { rawValue }

    var title: String {
        switch self {
        case .monthly: return "Monthly"
        case .sixMonths: return "6 Months"
        }
    }

    var price: String {
        switch self {
        case .monthly: return "4,99 €"
        case .sixMonths: return "14,99 €"
        }
    }

    var weeklyPrice: String {
        switch self {
        case .monthly: return "1,25 €"
        case .sixMonths: return "0,58 €"
        }
    }

    var savingsLabel: String? {
        switch self {
        case .monthly: return nil
        case .sixMonths: return "Save 50%"
        }
    }

    var period: String {
        switch self {
        case .monthly: return "/month"
        case .sixMonths: return "/6 months"
        }
    }
}

struct PaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: SubscriptionPlan = .sixMonths
    @State private var appeared = false
    @State private var pulsate = false

    private let features: [(icon: String, title: String, subtitle: String)] = [
        ("infinity", "Unlimited Date Ideas", "Fresh inspiration every single day"),
        ("bubble.left.and.bubble.right.fill", "Unlimited Questions", "365 unique conversation starters"),
        ("photo.stack.fill", "Memory Flash", "Relive your favorite moments together"),
        ("list.star", "Shared Wishlist", "Plan your dreams as a couple"),
        ("bell.badge.fill", "Smart Reminders", "Never miss an important date"),
    ]

    var body: some View {
        ZStack(alignment: .topTrailing) {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    featuresSection
                    plansSection
                    ctaSection
                    legalSection
                }
            }
            .scrollIndicators(.hidden)
            .background(
                LinearGradient(
                    stops: [
                        .init(color: Theme.cream, location: 0),
                        .init(color: Color(red: 1.0, green: 0.93, blue: 0.90), location: 0.4),
                        .init(color: Theme.cream, location: 1.0),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Theme.textSecondary)
                    .frame(width: 30, height: 30)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .padding(.trailing, 16)
            .padding(.top, 8)
        }
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Theme.coral.opacity(0.2), Theme.pink.opacity(0.05), .clear],
                            center: .center,
                            startRadius: 20,
                            endRadius: 100
                        )
                    )
                    .frame(width: 200, height: 200)
                    .scaleEffect(pulsate ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: pulsate)

                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(
                        LinearGradient(colors: [Theme.coral, Theme.pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .scaleEffect(appeared ? 1 : 0.6)
                    .opacity(appeared ? 1 : 0)
            }

            VStack(spacing: 8) {
                Text("BetweenUs")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)
                +
                Text(" Pro")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.coral)

                Text("Unlock everything for your love story")
                    .font(.system(.subheadline, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textSecondary)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 10)
        }
        .padding(.top, 24)
        .padding(.bottom, 20)
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.1)) {
                appeared = true
            }
            pulsate = true
        }
    }

    private var featuresSection: some View {
        VStack(spacing: 0) {
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                HStack(spacing: 14) {
                    Image(systemName: feature.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(
                            LinearGradient(colors: [Theme.coral, Theme.pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                            in: .rect(cornerRadius: 10)
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text(feature.title)
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Theme.warmBrown)
                        Text(feature.subtitle)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)
                    }

                    Spacer()

                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Theme.coral)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 15)
                .animation(.spring(response: 0.5).delay(0.1 + Double(index) * 0.06), value: appeared)

                if index < features.count - 1 {
                    Divider()
                        .padding(.leading, 70)
                        .padding(.trailing, 20)
                }
            }
        }
        .background(Theme.cardBackground, in: .rect(cornerRadius: 20))
        .overlay(RoundedRectangle(cornerRadius: 20).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 10, y: 5)
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    private var plansSection: some View {
        VStack(spacing: 12) {
            planCard(.sixMonths)
            planCard(.monthly)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }

    private func planCard(_ plan: SubscriptionPlan) -> some View {
        let isSelected = selectedPlan == plan

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selectedPlan = plan
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .stroke(isSelected ? Theme.coral : Theme.cardBorder, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    if isSelected {
                        Circle()
                            .fill(Theme.coral)
                            .frame(width: 14, height: 14)
                            .transition(.scale)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Text(plan.title)
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(Theme.warmBrown)

                        if let savings = plan.savingsLabel {
                            Text(savings)
                                .font(.system(.caption2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Theme.pink, in: Capsule())
                        }
                    }

                    Text(plan.price + plan.period)
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(plan.weeklyPrice)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(isSelected ? Theme.coral : Theme.warmBrown)
                    Text("/week")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(16)
            .background(
                isSelected ? Theme.coral.opacity(0.06) : Theme.cardBackground,
                in: .rect(cornerRadius: 18)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Theme.coral : Theme.cardBorder, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(color: isSelected ? Theme.coral.opacity(0.12) : Theme.softShadow, radius: isSelected ? 10 : 6, y: isSelected ? 5 : 3)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedPlan)
    }

    private var ctaSection: some View {
        VStack(spacing: 12) {
            Button {
                // Purchase logic placeholder
            } label: {
                HStack(spacing: 8) {
                    Text("Continue")
                        .font(.system(.headline, design: .rounded))
                    Image(systemName: "arrow.right")
                        .font(.system(.subheadline, weight: .bold))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .background(
                    LinearGradient(colors: [Theme.coral, Theme.pink], startPoint: .leading, endPoint: .trailing),
                    in: .rect(cornerRadius: 16)
                )
                .shadow(color: Theme.coral.opacity(0.35), radius: 12, y: 6)
            }
            .padding(.horizontal, 16)

            Text("3-day free trial, then \(selectedPlan.price)\(selectedPlan.period)")
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(Theme.textSecondary)
        }
        .padding(.bottom, 16)
    }

    private var legalSection: some View {
        HStack(spacing: 16) {
            Button { } label: {
                Text("Terms")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(Theme.textTertiary)
            }
            Button { } label: {
                Text("Privacy")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(Theme.textTertiary)
            }
            Button { } label: {
                Text("Restore")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(Theme.textTertiary)
            }
        }
        .padding(.bottom, 32)
    }
}
