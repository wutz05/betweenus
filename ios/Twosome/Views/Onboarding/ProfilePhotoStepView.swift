import SwiftUI
import PhotosUI

struct ProfilePhotoStepView: View {
    @Environment(AppDataStore.self) private var store
    @State private var selectedItem: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var appeared = false
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.coral)

                Text("Add a profile photo")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)

                Text("Optional — you can always add one later")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
            }
            .opacity(appeared ? 1 : 0)

            PhotosPicker(selection: $selectedItem, matching: .images) {
                if let photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Theme.coral, lineWidth: 3))
                } else {
                    ZStack {
                        Circle()
                            .fill(Theme.lightCoral)
                            .frame(width: 150, height: 150)
                        VStack(spacing: 8) {
                            Image(systemName: "person.crop.circle.badge.plus")
                                .font(.system(size: 40))
                                .foregroundStyle(Theme.coral)
                            Text("Choose Photo")
                                .font(.system(.caption, design: .rounded, weight: .semibold))
                                .foregroundStyle(Theme.coral)
                        }
                    }
                }
            }
            .opacity(appeared ? 1 : 0)
            .onChange(of: selectedItem) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self) {
                        photoData = data
                        store.coupleData.me.photoData = data
                    }
                }
            }

            Spacer()

            VStack(spacing: 12) {
                Button {
                    onContinue()
                } label: {
                    Text("Continue")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.coral, in: .rect(cornerRadius: 16))
                }

                if photoData == nil {
                    Button {
                        onContinue()
                    } label: {
                        Text("Skip for now")
                            .font(.system(.subheadline, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
        }
    }
}
