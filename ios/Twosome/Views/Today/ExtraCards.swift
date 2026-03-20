import SwiftUI

struct CountdownCard: View {
    let daysUntil: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "calendar.badge.clock")
                    .font(.subheadline)
                    .foregroundStyle(Theme.pink)
                Text("Next Anniversary")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(daysUntil)")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)
                Text(daysUntil == 1 ? "day away" : "days away")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding(16)
        .background(Theme.cardBackground, in: .rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 8, y: 4)
    }
}

struct DaysTogetherCard: View {
    let days: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "heart.text.square.fill")
                    .font(.subheadline)
                    .foregroundStyle(Theme.coral)
                Text("Days Together")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(days)")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)
                Text("days of love")
                    .font(.system(.body, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
        .padding(16)
        .background(Theme.cardBackground, in: .rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 8, y: 4)
    }
}
