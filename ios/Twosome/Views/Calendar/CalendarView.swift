import SwiftUI

struct CoupleCalendarView: View {
    @Environment(AppDataStore.self) private var store
    @State private var selectedDate: Date = Date()
    @State private var displayedMonth: Date = Date()
    @State private var showEventSheet = false
    @State private var showAddEvent = false

    private let calendar = Calendar.current
    private let daysOfWeek = ["S", "M", "T", "W", "T", "F", "S"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    monthHeader
                    calendarGrid
                    eventsList
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Calendar")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddEvent = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Theme.coral)
                    }
                }
            }
            .sheet(isPresented: $showAddEvent) {
                AddEventSheet()
            }
        }
    }

    private var monthHeader: some View {
        HStack {
            Button {
                withAnimation(.spring(response: 0.3)) {
                    displayedMonth = calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? displayedMonth
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
                    .foregroundStyle(Theme.coral)
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text(displayedMonth, format: .dateTime.month(.wide).year())
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(Theme.warmBrown)

            Spacer()

            Button {
                withAnimation(.spring(response: 0.3)) {
                    displayedMonth = calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? displayedMonth
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(Theme.coral)
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.top, 8)
    }

    private var calendarGrid: some View {
        let days = generateDays()

        return VStack(spacing: 4) {
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(.caption, design: .rounded, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 4) {
                ForEach(days, id: \.self) { date in
                    if let date {
                        dayCell(for: date)
                    } else {
                        Text("")
                            .frame(height: 44)
                    }
                }
            }
        }
        .padding(12)
        .background(Theme.cardBackground, in: .rect(cornerRadius: 18))
        .overlay(RoundedRectangle(cornerRadius: 18).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 8, y: 4)
    }

    private func dayCell(for date: Date) -> some View {
        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
        let isToday = calendar.isDateInToday(date)
        let hasEvents = store.hasEventsOnDate(date)

        return Button {
            withAnimation(.spring(response: 0.25)) { selectedDate = date }
        } label: {
            VStack(spacing: 2) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(.subheadline, design: .rounded, weight: isToday ? .bold : .regular))
                    .foregroundStyle(
                        isSelected ? .white :
                        isToday ? Theme.coral :
                        Theme.warmBrown
                    )

                Circle()
                    .fill(hasEvents ? (isSelected ? .white : Theme.coral) : .clear)
                    .frame(width: 5, height: 5)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(
                isSelected ? Theme.coral : Color.clear,
                in: .rect(cornerRadius: 10)
            )
        }
    }

    private var eventsList: some View {
        let events = store.eventsForDate(selectedDate)

        return VStack(alignment: .leading, spacing: 12) {
            Text(selectedDate, format: .dateTime.weekday(.wide).month(.wide).day())
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Theme.warmBrown)

            if events.isEmpty {
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.title2)
                            .foregroundStyle(Theme.textTertiary)
                        Text("No events on this day")
                            .font(.subheadline)
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.vertical, 24)
                    Spacer()
                }
            } else {
                ForEach(events) { event in
                    HStack(spacing: 12) {
                        Text(event.emoji)
                            .font(.title3)
                            .frame(width: 40, height: 40)
                            .background(Theme.lightCoral, in: .rect(cornerRadius: 10))

                        VStack(alignment: .leading, spacing: 2) {
                            Text(event.title)
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                .foregroundStyle(Theme.warmBrown)
                            if let note = event.note {
                                Text(note)
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)
                            }
                            if event.isRecurring {
                                Text("Recurring yearly")
                                    .font(.caption2)
                                    .foregroundStyle(Theme.textTertiary)
                            }
                        }
                        Spacer()
                    }
                    .padding(12)
                    .background(Theme.cardBackground, in: .rect(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Theme.cardBorder, lineWidth: 1))
                }
            }
        }
    }

    private func generateDays() -> [Date?] {
        let components = calendar.dateComponents([.year, .month], from: displayedMonth)
        guard let firstDay = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDay) else {
            return []
        }

        let weekday = calendar.component(.weekday, from: firstDay)
        var days: [Date?] = Array(repeating: nil, count: weekday - 1)

        for day in range {
            var comps = components
            comps.day = day
            days.append(calendar.date(from: comps))
        }

        return days
    }
}

struct AddEventSheet: View {
    @Environment(AppDataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var date: Date = Date()
    @State private var emoji: String = "📅"
    @State private var note: String = ""

    private let emojis = ["📅", "🎉", "🍽️", "✈️", "🎬", "🎁", "💕", "🏖️", "🎵", "⭐"]

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Event title", text: $title)
                        .foregroundStyle(Color(.label))
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                        .tint(Theme.coral)
                    TextField("Note (optional)", text: $note)
                        .foregroundStyle(Color(.label))
                }

                Section("Emoji") {
                    ScrollView(.horizontal) {
                        HStack(spacing: 8) {
                            ForEach(emojis, id: \.self) { e in
                                Button {
                                    emoji = e
                                } label: {
                                    Text(e)
                                        .font(.title2)
                                        .padding(8)
                                        .background(
                                            emoji == e ? Theme.lightCoral : Color(.tertiarySystemFill),
                                            in: .rect(cornerRadius: 8)
                                        )
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let event = CoupleEvent(
                            title: title,
                            date: date,
                            emoji: emoji,
                            type: .custom,
                            note: note.isEmpty ? nil : note
                        )
                        store.addCustomEvent(event)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .foregroundStyle(Theme.coral)
                }
            }
        }
    }
}
