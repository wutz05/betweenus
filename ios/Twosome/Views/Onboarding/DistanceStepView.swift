import SwiftUI

struct DistanceStepView: View {
    @Environment(AppDataStore.self) private var store
    let onContinue: () -> Void

    @State private var liveTogether: Bool = false
    @State private var distance: Double = 25
    @State private var appeared: Bool = false

    private let maxDistance: Double = 500

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 28) {
                Image(systemName: liveTogether ? "house.fill" : "location.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(
                        LinearGradient(colors: [Theme.coral, Theme.pink], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .contentTransition(.symbolEffect(.replace))
                    .scaleEffect(appeared ? 1 : 0.5)
                    .opacity(appeared ? 1 : 0)

                VStack(spacing: 8) {
                    Text("How far apart?")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(Theme.warmBrown)

                    Text("Tell us about your living situation")
                        .font(.system(.subheadline, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.textSecondary)
                }
                .opacity(appeared ? 1 : 0)

                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                        liveTogether.toggle()
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: liveTogether ? "checkmark.circle.fill" : "circle")
                            .font(.title3)
                            .foregroundStyle(liveTogether ? Theme.coral : Theme.textSecondary)
                            .contentTransition(.symbolEffect(.replace))

                        Text("We live together")
                            .font(.system(.body, design: .rounded, weight: .medium))
                            .foregroundStyle(Theme.warmBrown)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        liveTogether ? Theme.coral.opacity(0.12) : Color(.secondarySystemBackground),
                        in: .rect(cornerRadius: 16)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(liveTogether ? Theme.coral.opacity(0.4) : Color.clear, lineWidth: 1.5)
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .opacity(appeared ? 1 : 0)

                if !liveTogether {
                    VStack(spacing: 20) {
                        Text(distanceLabel)
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundStyle(Theme.coral)
                            .contentTransition(.numericText(value: distance))
                            .animation(.snappy, value: distance)

                        VStack(spacing: 8) {
                            Slider(value: $distance, in: 1...maxDistance, step: 1)
                                .tint(Theme.coral)
                                .padding(.horizontal, 24)

                            HStack {
                                Text("1 km")
                                    .font(.system(.caption2, design: .rounded))
                                    .foregroundStyle(Theme.textTertiary)
                                Spacer()
                                Text("500+ km")
                                    .font(.system(.caption2, design: .rounded))
                                    .foregroundStyle(Theme.textTertiary)
                            }
                            .padding(.horizontal, 28)
                        }

                        Text(distanceDescription)
                            .font(.system(.caption, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textSecondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .animation(.easeInOut(duration: 0.3), value: distanceTier)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)).combined(with: .scale(scale: 0.95)))
                }
            }

            Spacer()

            Button {
                if liveTogether {
                    store.coupleData.distanceKm = 0
                } else {
                    store.coupleData.distanceKm = Int(distance)
                }
                onContinue()
            } label: {
                Text("Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.coral, in: .rect(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(appeared ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.7, dampingFraction: 0.7).delay(0.15)) {
                appeared = true
            }
        }
    }

    private var distanceLabel: String {
        if distance >= maxDistance {
            return "500+ km"
        }
        return "\(Int(distance)) km"
    }

    private var distanceTier: Int {
        if distance < 20 { return 0 }
        if distance < 100 { return 1 }
        if distance < 300 { return 2 }
        return 3
    }

    private var distanceDescription: String {
        switch distanceTier {
        case 0: return "Close enough for spontaneous dates 💕"
        case 1: return "A little drive, but totally worth it 🚗"
        case 2: return "Distance makes the heart grow fonder 💌"
        default: return "True love knows no distance ✈️"
        }
    }
}
