import SwiftUI

struct CustomizeSheet: View {
    @Environment(AppDataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMascot: MascotType = .bears

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 8) {
                        Text("Choose your mascot")
                            .font(.system(.headline, design: .rounded))
                            .foregroundStyle(Theme.warmBrown)
                        Text("Pick the couple that represents you two")
                            .font(.system(.subheadline, design: .serif))
                            .italic()
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 8)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(MascotType.allCases) { mascot in
                            mascotOption(mascot)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.bottom, 24)
            }
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle("Customize")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        store.setMascot(selectedMascot)
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded, weight: .semibold))
                    .foregroundStyle(Theme.coral)
                }
            }
            .onAppear {
                selectedMascot = store.selectedMascot
            }
        }
    }

    private func mascotOption(_ mascot: MascotType) -> some View {
        let isSelected = selectedMascot == mascot
        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                selectedMascot = mascot
            }
        } label: {
            VStack(spacing: 10) {
                if let img = UIImage(named: mascot.imageName) {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                } else {
                    Text(mascot.emoji)
                        .font(.system(size: 56))
                        .frame(height: 100)
                }

                Text(mascot.displayName)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : Theme.warmBrown)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .padding(.horizontal, 8)
            .background(
                isSelected ? Theme.coral : Theme.cardBackground,
                in: .rect(cornerRadius: 20)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.clear : Theme.cardBorder, lineWidth: 1)
            )
            .shadow(color: isSelected ? Theme.coral.opacity(0.3) : Theme.softShadow, radius: isSelected ? 10 : 6, y: isSelected ? 5 : 3)
            .scaleEffect(isSelected ? 1.03 : 1.0)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selectedMascot)
    }
}
