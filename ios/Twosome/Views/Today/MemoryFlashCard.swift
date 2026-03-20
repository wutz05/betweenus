import SwiftUI

struct MemoryFlashCard: View {
    @Environment(AppDataStore.self) private var store
    @State private var showFullPhoto = false

    var body: some View {
        Button {
            if store.memoryPhoto != nil {
                showFullPhoto = true
            }
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.subheadline)
                        .foregroundStyle(Theme.pink)
                    Text("Memory Flash")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                    if store.memoryPhoto != nil {
                        Text("1 year ago")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }

                if let photo = store.memoryPhoto, let uiImage = UIImage(data: photo.imageData) {
                    Color(.secondarySystemBackground)
                        .frame(height: 180)
                        .overlay {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .allowsHitTesting(false)
                        }
                        .clipShape(.rect(cornerRadius: 14))
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "camera.fill")
                            .font(.title2)
                            .foregroundStyle(Theme.coral.opacity(0.6))
                        Text("Add your first photo together")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)
                        Text("Photos will appear here as memories")
                            .font(.caption)
                            .foregroundStyle(Theme.textTertiary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(Theme.lightCoral, in: .rect(cornerRadius: 14))
                }
            }
            .padding(16)
            .background(Theme.cardBackground, in: .rect(cornerRadius: 22))
            .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.cardBorder, lineWidth: 1))
            .shadow(color: Theme.softShadow, radius: 8, y: 4)
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showFullPhoto) {
            if let photo = store.memoryPhoto, let uiImage = UIImage(data: photo.imageData) {
                PhotoFullScreenView(image: uiImage, date: photo.date)
            }
        }
    }
}

struct PhotoFullScreenView: View {
    let image: UIImage
    let date: Date
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)

            VStack {
                HStack {
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding()
                }
                Spacer()
                Text(date, style: .date)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom, 40)
            }
        }
    }
}
