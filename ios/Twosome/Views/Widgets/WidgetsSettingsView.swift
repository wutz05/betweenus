import SwiftUI

struct WidgetsSettingsView: View {
    @Environment(AppDataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showWishlist = false

    var body: some View {
        @Bindable var store = store

        NavigationStack {
            List {
                Section {
                    widgetToggle(
                        icon: "bubble.left.and.bubble.right.fill",
                        title: "Daily Question",
                        description: "A new intimate question every day",
                        isOn: $store.widgetConfig.showDailyQuestion
                    )
                    widgetToggle(
                        icon: "lightbulb.fill",
                        title: "Date Ideas",
                        description: "Fun date suggestions based on the season",
                        isOn: $store.widgetConfig.showDateSpark
                    )
                    widgetToggle(
                        icon: "photo.on.rectangle.angled",
                        title: "Memory Flash",
                        description: "Photos from this day in your history",
                        isOn: $store.widgetConfig.showMemoryFlash
                    )
                } header: {
                    Text("Main Cards")
                }

                Section {
                    widgetToggle(
                        icon: "calendar.badge.clock",
                        title: "Anniversary Countdown",
                        description: "Days until your next anniversary",
                        isOn: $store.widgetConfig.showCountdown
                    )
                    widgetToggle(
                        icon: "heart.text.square.fill",
                        title: "Days Together",
                        description: "Live counter of days since you became a couple",
                        isOn: $store.widgetConfig.showDaysTogether
                    )
                    widgetToggle(
                        icon: "list.star",
                        title: "Shared Wishlist",
                        description: "Date ideas, travel dreams, restaurants to try",
                        isOn: $store.widgetConfig.showWishlist
                    )
                } header: {
                    Text("Extra Widgets")
                }

                if store.widgetConfig.showWishlist {
                    Section {
                        Button {
                            showWishlist = true
                        } label: {
                            HStack {
                                Image(systemName: "pencil.and.list.clipboard")
                                    .foregroundStyle(Theme.coral)
                                Text("Manage Wishlist")
                                    .foregroundStyle(Theme.warmBrown)
                                Spacer()
                                Text("\(store.wishlistItems.count) items")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textSecondary)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(Theme.textTertiary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Widgets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.coral)
                }
            }
            .sheet(isPresented: $showWishlist) {
                WishlistSheet()
            }
        }
    }

    private func widgetToggle(icon: String, title: String, description: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(Theme.coral)
                    .frame(width: 28)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    Text(description)
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .tint(Theme.coral)
    }
}

struct WishlistSheet: View {
    @Environment(AppDataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var newItemTitle: String = ""
    @State private var selectedCategory: WishlistItem.WishlistCategory = .dateIdea

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 8) {
                        TextField("Add a wish...", text: $newItemTitle)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(Color(.label))
                        Picker("", selection: $selectedCategory) {
                            ForEach(WishlistItem.WishlistCategory.allCases, id: \.self) { cat in
                                Text(cat.rawValue).tag(cat)
                            }
                        }
                        .labelsHidden()
                        .tint(Theme.coral)
                        Button {
                            guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                            store.addWishlistItem(WishlistItem(title: newItemTitle, category: selectedCategory))
                            newItemTitle = ""
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Theme.coral)
                        }
                    }
                }

                ForEach(WishlistItem.WishlistCategory.allCases, id: \.self) { category in
                    let items = store.wishlistItems.filter { $0.category == category }
                    if !items.isEmpty {
                        Section(category.rawValue) {
                            ForEach(items) { item in
                                HStack {
                                    Button {
                                        store.toggleWishlistItem(item)
                                    } label: {
                                        Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundStyle(item.isCompleted ? .green : .secondary)
                                    }
                                    Text(item.title)
                                        .font(.system(.body, design: .rounded))
                                        .strikethrough(item.isCompleted)
                                        .foregroundStyle(item.isCompleted ? .secondary : .primary)
                                    Spacer()
                                }
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        store.deleteWishlistItem(item)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Shared Wishlist")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Theme.coral)
                }
            }
        }
    }
}
