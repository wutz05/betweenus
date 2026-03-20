import SwiftUI

struct AnniversaryStepView: View {
    @Environment(AppDataStore.self) private var store
    @State private var anniversaryDate: Date = Date()
    @State private var appeared = false
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.pink)

                Text("When did you become\na couple?")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)
                    .multilineTextAlignment(.center)

                Text("We'll celebrate your anniversaries automatically")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(appeared ? 1 : 0)

            DatePicker(
                "Anniversary",
                selection: $anniversaryDate,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Theme.coral)
            .padding(12)
            .background(Color(.systemBackground), in: .rect(cornerRadius: 16))
            .padding(.horizontal, 24)
            .opacity(appeared ? 1 : 0)

            Spacer()

            Button {
                store.coupleData.anniversaryDate = anniversaryDate
                onContinue()
            } label: {
                Text("Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.coral, in: .rect(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
        }
    }
}
