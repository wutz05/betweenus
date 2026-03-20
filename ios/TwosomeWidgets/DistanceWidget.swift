import WidgetKit
import SwiftUI

nonisolated struct DistanceEntry: TimelineEntry {
    let date: Date
    let distanceKm: Int?
    let myName: String
    let partnerName: String
}

nonisolated struct DistanceProvider: TimelineProvider {
    func placeholder(in context: Context) -> DistanceEntry {
        DistanceEntry(date: .now, distanceKm: 42, myName: "You", partnerName: "Partner")
    }

    func getSnapshot(in context: Context, completion: @escaping (DistanceEntry) -> Void) {
        let data = SharedDataManager.load()
        completion(DistanceEntry(date: .now, distanceKm: data.distanceKm, myName: data.myName, partnerName: data.partnerName))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<DistanceEntry>) -> Void) {
        let data = SharedDataManager.load()
        let entry = DistanceEntry(date: .now, distanceKm: data.distanceKm, myName: data.myName, partnerName: data.partnerName)
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(1800))))
    }
}

struct DistanceWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: DistanceEntry

    var body: some View {
        if let distance = entry.distanceKm {
            if distance == 0 {
                togetherView
            } else {
                distanceView(distance)
            }
        } else {
            noDataView
        }
    }

    private func distanceView(_ distance: Int) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "location.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(colors: [Color(red: 1.0, green: 0.55, blue: 0.40), Color(red: 1.0, green: 0.42, blue: 0.54)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )

            Text("\(distance)")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))
            +
            Text(" km")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.secondary)

            Text("apart")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.secondary)

            if !entry.myName.isEmpty && !entry.partnerName.isEmpty {
                HStack(spacing: 4) {
                    Text(entry.myName)
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.system(size: 8))
                    Text(entry.partnerName)
                        .font(.system(.caption2, design: .rounded, weight: .medium))
                }
                .foregroundStyle(Color(red: 1.0, green: 0.55, blue: 0.40))
                .lineLimit(1)
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 1.0, green: 0.96, blue: 0.94)
        }
    }

    private var togetherView: some View {
        VStack(spacing: 8) {
            Image(systemName: "house.fill")
                .font(.title2)
                .foregroundStyle(
                    LinearGradient(colors: [Color(red: 1.0, green: 0.55, blue: 0.40), Color(red: 1.0, green: 0.42, blue: 0.54)], startPoint: .topLeading, endPoint: .bottomTrailing)
                )

            Text("Together")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))

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

    private var noDataView: some View {
        VStack(spacing: 8) {
            Image(systemName: "location.slash.fill")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("Set distance")
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)

            Text("Open BetweenUs")
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(.tertiary)
        }
        .containerBackground(for: .widget) {
            Color(red: 1.0, green: 0.96, blue: 0.94)
        }
    }
}

struct DistanceWidget: Widget {
    let kind = "DistanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: DistanceProvider()) { entry in
            DistanceWidgetView(entry: entry)
        }
        .configurationDisplayName("Distance")
        .description("See the distance between you and your partner")
        .supportedFamilies([.systemSmall])
    }
}
