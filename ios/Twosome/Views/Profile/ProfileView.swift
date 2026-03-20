import SwiftUI
import PhotosUI

struct ProfileView: View {
    @Environment(AppDataStore.self) private var store
    @State private var showPhotosPicker = false
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var showDisconnectAlert = false
    @State private var showEditNames = false
    @State private var showPaywall = false
    @State private var showWidgetsSettings = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    avatarsSection
                    proCard
                    statsSection
                    photosSection
                    widgetsRow
                    settingsSection
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Profile")
            .sheet(isPresented: $showEditNames) {
                EditNamesSheet()
            }
            .fullScreenCover(isPresented: $showPaywall) {
                PaywallView()
            }
            .sheet(isPresented: $showWidgetsSettings) {
                WidgetsSettingsView()
            }
            .alert("Disconnect Partner?", isPresented: $showDisconnectAlert) {
                Button("Disconnect", role: .destructive) {
                    resetData()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This will reset all shared data. This action cannot be undone.")
            }
        }
    }

    private var avatarsSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 24) {
                avatarView(
                    name: store.coupleData.me.name,
                    photoData: store.coupleData.me.photoData
                )
                Image(systemName: "heart.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.pink)
                    .symbolEffect(.pulse)
                avatarView(
                    name: store.coupleData.partner.name,
                    photoData: store.coupleData.partner.photoData
                )
            }

            Text("\(store.coupleData.me.name) & \(store.coupleData.partner.name)")
                .font(.system(.title3, design: .serif, weight: .semibold))
                .foregroundStyle(Theme.warmBrown)

            if !store.timeTogetherString.isEmpty {
                Text(store.timeTogetherString)
                    .font(.system(.caption, design: .serif))
                    .italic()
                    .foregroundStyle(Theme.textSecondary)
            }

            if !store.coupleData.inviteCode.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "link")
                        .font(.caption2)
                    Text("Code: \(store.coupleData.inviteCode)")
                        .font(.system(.caption, design: .monospaced))
                }
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Theme.lightCoral, in: Capsule())
            }
        }
        .padding(.top, 8)
    }

    private var proCard: some View {
        Button {
            showPaywall = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "crown.fill")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(
                        LinearGradient(colors: [Theme.coral, Theme.pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                        in: .rect(cornerRadius: 12)
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text("Upgrade to Pro")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(Theme.warmBrown)
                    Text("Unlock all features for your love story")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.coral)
            }
            .padding(14)
            .background(
                LinearGradient(
                    colors: [Theme.coral.opacity(0.08), Theme.pink.opacity(0.06)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: .rect(cornerRadius: 18)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Theme.coral.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func avatarView(name: String, photoData: Data?) -> some View {
        VStack(spacing: 6) {
            if let photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Theme.coral.opacity(0.3), lineWidth: 2))
            } else {
                Circle()
                    .fill(Theme.lightCoral)
                    .frame(width: 72, height: 72)
                    .overlay {
                        Text(String(name.prefix(1)).uppercased())
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .foregroundStyle(Theme.coral)
                    }
            }
            Text(name)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(Theme.warmBrown)
        }
    }

    private var statsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCard(value: "\(store.daysTogether)", label: "Days Together", icon: "heart.fill")
            statCard(value: "\(store.coupleData.streakRecord)", label: "Streak Record", icon: "flame.fill")
            statCard(value: "\(store.coupleData.questionsAnswered)", label: "Questions", icon: "bubble.fill")
            statCard(value: "\(store.coupleData.dateSparksAccepted)", label: "Date Sparks", icon: "sparkles")
        }
    }

    private func statCard(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Theme.coral)
            Text(value)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Theme.warmBrown)
            Text(label)
                .font(.system(.caption2, design: .rounded))
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Theme.cardBackground, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 6, y: 3)
    }

    private var photosSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Our Photos")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(Theme.warmBrown)
                Spacer()
                PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 5, matching: .images) {
                    Label("Add", systemImage: "plus")
                        .font(.system(.subheadline, design: .rounded, weight: .medium))
                        .foregroundStyle(Theme.coral)
                }
            }

            if store.photos.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "photo.stack")
                        .font(.title2)
                        .foregroundStyle(Theme.textTertiary)
                    Text("No photos yet")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(Theme.cardBackground, in: .rect(cornerRadius: 16))
                .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardBorder, lineWidth: 1))
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(store.photos.suffix(10)) { photo in
                            if let uiImage = UIImage(data: photo.imageData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .clipShape(.rect(cornerRadius: 10))
                            }
                        }
                    }
                }
                .contentMargins(.horizontal, 0)
                .scrollIndicators(.hidden)
            }
        }
        .onChange(of: selectedPhotos) { _, newValue in
            Task {
                for item in newValue {
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        store.addPhoto(data)
                    }
                }
                selectedPhotos = []
            }
        }
    }

    private var widgetsRow: some View {
        Button {
            showWidgetsSettings = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "square.grid.2x2")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(Theme.coral, in: .rect(cornerRadius: 10))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Manage Widgets")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Theme.warmBrown)
                    Text("Toggle cards on your home screen")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(14)
            .background(Theme.cardBackground, in: .rect(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardBorder, lineWidth: 1))
            .shadow(color: Theme.softShadow, radius: 6, y: 3)
        }
        .buttonStyle(.plain)
    }

    private var settingsSection: some View {
        VStack(spacing: 0) {
            settingsRow(icon: "pencil", title: "Edit Names") {
                showEditNames = true
            }
            Divider().padding(.leading, 48)
            settingsRow(icon: "bell.fill", title: "Notifications") { }
            Divider().padding(.leading, 48)
            settingsRow(icon: "arrow.triangle.2.circlepath", title: "Reconnect Partner") { }
            Divider().padding(.leading, 48)
            settingsRow(icon: "xmark.circle", title: "Disconnect", isDestructive: true) {
                showDisconnectAlert = true
            }
        }
        .background(Theme.cardBackground, in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.cardBorder, lineWidth: 1))
        .shadow(color: Theme.softShadow, radius: 6, y: 3)
    }

    private func settingsRow(icon: String, title: String, isDestructive: Bool = false, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundStyle(isDestructive ? .red : Theme.coral)
                    .frame(width: 24)
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(isDestructive ? .red : Theme.warmBrown)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundStyle(Theme.textTertiary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }

    private func resetData() {
        UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        UserDefaults.standard.removeObject(forKey: "coupleData")
        UserDefaults.standard.removeObject(forKey: "events")
        UserDefaults.standard.removeObject(forKey: "dailyAnswers")
        UserDefaults.standard.removeObject(forKey: "dateSparkResponses")
        UserDefaults.standard.removeObject(forKey: "widgetConfig")
        UserDefaults.standard.removeObject(forKey: "wishlistItems")
        UserDefaults.standard.removeObject(forKey: "photos")
        UserDefaults.standard.removeObject(forKey: "quizProgress")
        store.hasCompletedOnboarding = false
    }
}

struct EditNamesSheet: View {
    @Environment(AppDataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var myName: String = ""
    @State private var partnerName: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Your Name") {
                    TextField("Your name", text: $myName)
                        .foregroundStyle(Color(.label))
                        .textContentType(.givenName)
                }
                Section("Partner's Name") {
                    TextField("Partner's name", text: $partnerName)
                        .foregroundStyle(Color(.label))
                        .textContentType(.givenName)
                }
            }
            .navigationTitle("Edit Names")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.coupleData.me.name = myName.trimmingCharacters(in: .whitespaces)
                        store.coupleData.partner.name = partnerName.trimmingCharacters(in: .whitespaces)
                        dismiss()
                    }
                    .disabled(myName.trimmingCharacters(in: .whitespaces).isEmpty || partnerName.trimmingCharacters(in: .whitespaces).isEmpty)
                    .foregroundStyle(Theme.coral)
                }
            }
            .onAppear {
                myName = store.coupleData.me.name
                partnerName = store.coupleData.partner.name
            }
        }
    }
}
