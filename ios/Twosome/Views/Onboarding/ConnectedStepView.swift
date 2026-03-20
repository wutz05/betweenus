import SwiftUI

struct ConnectedStepView: View {
    @Environment(AppDataStore.self) private var store
    let onFinish: () -> Void
    @State private var appeared = false
    @State private var showConfetti = false

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Spacer()

                if let bearsImage = UIImage(named: "bears_together") {
                    Image(uiImage: bearsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 220, height: 220)
                        .scaleEffect(appeared ? 1 : 0.5)
                        .opacity(appeared ? 1 : 0)
                } else {
                    Image(systemName: "heart.circle.fill")
                        .font(.system(size: 100))
                        .foregroundStyle(Theme.pink)
                        .scaleEffect(appeared ? 1 : 0.5)
                        .opacity(appeared ? 1 : 0)
                }

                VStack(spacing: 8) {
                    Text("You're connected!")
                        .font(.system(.title, design: .rounded, weight: .bold))
                        .foregroundStyle(Theme.warmBrown)

                    Text("\(store.coupleData.me.name) & \(store.coupleData.partner.name)")
                        .font(.system(.title3, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.coral)

                    Text("Your journey together starts now")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                        .padding(.top, 4)
                }
                .opacity(appeared ? 1 : 0)

                Spacer()

                Button {
                    onFinish()
                } label: {
                    Text("Let's Go!")
                        .font(.system(.headline, design: .rounded))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.coral, in: .rect(cornerRadius: 16))
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(appeared ? 1 : 0)
            }

            if showConfetti {
                ConfettiView()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
                appeared = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                showConfetti = true
            }
        }
    }
}
