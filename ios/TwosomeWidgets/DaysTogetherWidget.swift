import WidgetKit
import SwiftUI

nonisolated struct DaysTogetherEntry: TimelineEntry {
    let date: Date
    let myName: String
    let partnerName: String
    let anniversaryDate: Date?
}

nonisolated struct DaysTogetherProvider: TimelineProvider {
    func placeholder(in context: Context) -> DaysTogetherEntry {
        DaysTogetherEntry(date: .now, myName: "You", partnerName: "Partner", anniversaryDate: Calendar.current.date(byAdding: .year, value: -2, to: .now))
    }

    func getSnapshot(in context: Context, completion: @escaping (DaysTogetherEntry) -> Void) {
        let data = SharedDataManager.load()
        completion(DaysTogetherEntry(date: .now, myName: data.myName, partnerName: data.partnerName, anniversaryDate: data.anniversaryDate))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DaysTogetherEntry>) -> Void) {
        let data = SharedDataManager.load()
        let entry = DaysTogetherEntry(date: .now, myName: data.myName, partnerName: data.partnerName, anniversaryDate: data.anniversaryDate)
        let midnight = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

struct DaysTogetherWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: DaysTogetherEntry

    private var daysTogether: Int {
        guard let anniversary = entry.anniversaryDate else { return 0 }
        return max(0, Calendar.current.dateComponents([.day], from: anniversary, to: entry.date).day ?? 0)
    }

    private var detailedTime: (years: Int, months: Int, days: Int) {
        guard let anniversary = entry.anniversaryDate else { return (0, 0, 0) }
        let comps = Calendar.current.dateComponents([.year, .month, .day], from: anniversary, to: entry.date)
        return (comps.year ?? 0, comps.month ?? 0, comps.day ?? 0)
    }

    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        default:
            mediumView
        }
    }

    private var smallView: some View {
        VStack(spacing: 6) {
            Image(systemName: "heart.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(colors: [Color(red: 1.0, green: 0.55, blue: 0.40), Color(red: 1.0, green: 0.42, blue: 0.54)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )

            Text("\(daysTogether)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))
                .contentTransition(.numericText())

            Text("days together")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)

            if !entry.myName.isEmpty && !entry.partnerName.isEmpty {
                Text("\(entry.myName) & \(entry.partnerName)")
                    .font(.system(.caption2, design: .serif))
                    .foregroundStyle(Color(red: 1.0, green: 0.55, blue: 0.40))
                    .lineLimit(1)
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 1.0, green: 0.96, blue: 0.94)
        }
    }

    private var mediumView: some View {
        let time = detailedTime
        return HStack(spacing: 16) {
            VStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundStyle(
                        LinearGradient(colors: [Color(red: 1.0, green: 0.55, blue: 0.40), Color(red: 1.0, green: 0.42, blue: 0.54)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                if !entry.myName.isEmpty && !entry.partnerName.isEmpty {
                    Text("\(entry.myName) & \(entry.partnerName)")
                        .font(.system(.caption, design: .serif))
                        .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 8) {
                Text("\(daysTogether) days")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))

                HStack(spacing: 12) {
                    timeUnit(value: time.years, label: "yrs")
                    timeUnit(value: time.months, label: "mo")
                    timeUnit(value: time.days, label: "days")
                }
            }
            .frame(maxWidth: .infinity)
        }
        .containerBackground(for: .widget) {
            Color(red: 1.0, green: 0.96, blue: 0.94)
        }
    }

    private func timeUnit(value: Int, label: String) -> some View {
        VStack(spacing: 2) {
            Text("\(value)")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(Color(red: 1.0, green: 0.55, blue: 0.40))
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)
        }
    }
}

struct DaysTogetherWidget: Widget {
    let kind = "DaysTogetherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DaysTogetherProvider()) { entry in
            DaysTogetherWidgetView(entry: entry)
        }
        .configurationDisplayName("Days Together")
        .description("See how long you've been together")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
