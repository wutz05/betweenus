import WidgetKit
import SwiftUI

nonisolated struct EventsEntry: TimelineEntry {
    let date: Date
    let events: [SharedEvent]
    let myName: String
    let partnerName: String
}

nonisolated struct EventsProvider: TimelineProvider {
    func placeholder(in context: Context) -> EventsEntry {
        let sample = [
            SharedEvent(title: "Anniversary", date: Date().addingTimeInterval(86400 * 14), emoji: "💍"),
            SharedEvent(title: "Valentine's Day", date: Date().addingTimeInterval(86400 * 30), emoji: "❤️"),
        ]
        return EventsEntry(date: .now, events: sample, myName: "You", partnerName: "Partner")
    }

    func getSnapshot(in context: Context, completion: @escaping (EventsEntry) -> Void) {
        let data = SharedDataManager.load()
        completion(EventsEntry(date: .now, events: data.upcomingEvents, myName: data.myName, partnerName: data.partnerName))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<EventsEntry>) -> Void) {
        let data = SharedDataManager.load()
        let entry = EventsEntry(date: .now, events: data.upcomingEvents, myName: data.myName, partnerName: data.partnerName)
        let midnight = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: .now)!)
        completion(Timeline(entries: [entry], policy: .after(midnight)))
    }
}

struct UpcomingEventsWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: EventsEntry

    private var upcomingEvents: [SharedEvent] {
        let now = Calendar.current.startOfDay(for: entry.date)
        return entry.events
            .filter { Calendar.current.startOfDay(for: $0.date) >= now }
            .sorted { $0.date < $1.date }
    }

    var body: some View {
        switch family {
        case .systemSmall:
            smallView
        case .systemMedium:
            mediumView
        default:
            mediumView
        }
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 4) {
                Image(systemName: "calendar.badge.clock")
                    .font(.caption)
                    .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.54))
                Text("Upcoming")
                    .font(.system(.caption2, design: .rounded, weight: .semibold))
                    .foregroundStyle(.secondary)
            }

            if upcomingEvents.isEmpty {
                Spacer()
                VStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.title3)
                        .foregroundStyle(.tertiary)
                    Text("No events")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity)
                Spacer()
            } else {
                ForEach(Array(upcomingEvents.prefix(3).enumerated()), id: \.offset) { _, event in
                    eventRow(event, compact: true)
                }
                Spacer(minLength: 0)
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 1.0, green: 0.96, blue: 0.94)
        }
    }

    private var mediumView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "calendar.badge.clock")
                    .font(.subheadline)
                    .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.54))
                Text("Upcoming Events")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))
                Spacer()
            }

            if upcomingEvents.isEmpty {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 6) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundStyle(.tertiary)
                        Text("No upcoming events")
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(.tertiary)
                    }
                    Spacer()
                }
                Spacer()
            } else {
                ForEach(Array(upcomingEvents.prefix(3).enumerated()), id: \.offset) { _, event in
                    eventRow(event, compact: false)
                }
                Spacer(minLength: 0)
            }
        }
        .containerBackground(for: .widget) {
            Color(red: 1.0, green: 0.96, blue: 0.94)
        }
    }

    private func eventRow(_ event: SharedEvent, compact: Bool) -> some View {
        let daysUntil = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: entry.date), to: Calendar.current.startOfDay(for: event.date)).day ?? 0

        return HStack(spacing: compact ? 6 : 10) {
            Text(event.emoji)
                .font(compact ? .caption : .subheadline)

            VStack(alignment: .leading, spacing: 0) {
                Text(event.title)
                    .font(.system(compact ? .caption2 : .caption, design: .rounded, weight: .medium))
                    .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))
                    .lineLimit(1)
                if !compact {
                    Text(event.date, format: .dateTime.month(.abbreviated).day())
                        .font(.system(.caption2, design: .rounded))
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Text(daysUntil == 0 ? "Today" : "\(daysUntil)d")
                .font(.system(compact ? .caption2 : .caption, design: .rounded, weight: .semibold))
                .foregroundStyle(daysUntil <= 7 ? Color(red: 1.0, green: 0.55, blue: 0.40) : .secondary)
        }
    }
}

struct UpcomingEventsWidget: Widget {
    let kind = "UpcomingEventsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EventsProvider()) { entry in
            UpcomingEventsWidgetView(entry: entry)
        }
        .configurationDisplayName("Upcoming Events")
        .description("See your upcoming couple events")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
