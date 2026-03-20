import SwiftUI

struct StreakPill: View {
    let count: Int

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "flame.fill")
                .font(.caption)
                .foregroundStyle(.white)
                .symbolEffect(.bounce, value: count)
            Text("\(count)")
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Theme.coral, in: Capsule())
    }
}
