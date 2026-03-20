import WidgetKit
import SwiftUI

nonisolated struct MessageEntry: TimelineEntry {
    let date: Date
    let message: String?
    let senderName: String?
    let messageDate: Date?
    let myName: String
    let partnerName: String
}

nonisolated struct MessageProvider: TimelineProvider {
    func placeholder(in context: Context) -> MessageEntry {
        MessageEntry(date: .now, message: "I love you!", senderName: "Partner", messageDate: .now, myName: "You", partnerName: "Partner")
    }

    func getSnapshot(in context: Context, completion: @escaping (MessageEntry) -> Void) {
        let data = SharedDataManager.load()
        completion(MessageEntry(date: .now, message: data.latestMessage, senderName: data.latestMessageSender, messageDate: data.latestMessageDate, myName: data.myName, partnerName: data.partnerName))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MessageEntry>) -> Void) {
        let data = SharedDataManager.load()
        let entry = MessageEntry(date: .now, message: data.latestMessage, senderName: data.latestMessageSender, messageDate: data.latestMessageDate, myName: data.myName, partnerName: data.partnerName)
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(3600))))
    }
}

struct MessageWidgetView: View {
    @Environment(\.widgetFamily) var family
    var entry: MessageEntry

    var body: some View {
        if let message = entry.message, let sender = entry.senderName {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "envelope.heart.fill")
                        .font(.caption)
                        .foregroundStyle(Color(red: 1.0, green: 0.42, blue: 0.54))
                    Text("from \(sender)")
                        .font(.system(.caption2, design: .rounded, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    if let msgDate = entry.messageDate {
                        Text(msgDate, style: .relative)
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(.tertiary)
                    }
                }

                Text(message)
                    .font(.system(family == .systemSmall ? .subheadline : .body, design: .serif))
                    .italic()
                    .foregroundStyle(Color(red: 0.36, green: 0.20, blue: 0.16))
                    .lineLimit(family == .systemSmall ? 3 : 4)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer(minLength: 0)

                HStack {
                    Spacer()
                    Image(systemName: "heart.fill")
                        .font(.caption2)
                        .foregroundStyle(Color(red: 1.0, green: 0.55, blue: 0.40).opacity(0.5))
                }
            }
            .containerBackground(for: .widget) {
                Color(red: 1.0, green: 0.96, blue: 0.94)
            }
        } else {
            VStack(spacing: 10) {
                Image(systemName: "envelope.heart.fill")
                    .font(.largeTitle)
                    .foregroundStyle(
                        LinearGradient(colors: [Color(red: 1.0, green: 0.55, blue: 0.40), Color(red: 1.0, green: 0.42, blue: 0.54)], startPoint: .topLeading, endPoint: .bottomTrailing)
                    )

                Text("No messages yet")
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)

                Text("Send a note in BetweenUs")
                    .font(.system(.caption2, design: .rounded))
                    .foregroundStyle(.tertiary)
            }
            .containerBackground(for: .widget) {
                Color(red: 1.0, green: 0.96, blue: 0.94)
            }
        }
    }
}

struct MessageWidget: Widget {
    let kind = "MessageWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MessageProvider()) { entry in
            MessageWidgetView(entry: entry)
        }
        .configurationDisplayName("Love Notes")
        .description("See the latest message from your partner")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
