import SwiftUI

struct WelcomeStepView: View {
    let onContinue: () -> Void
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                if let bearsImage = UIImage(named: "bears_together") {
                    Image(uiImage: bearsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .scaleEffect(appeared ? 1 : 0.8)
                        .opacity(appeared ? 1 : 0)
                } else {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(Theme.coral)
                        .scaleEffect(appeared ? 1 : 0.8)
                        .opacity(appeared ? 1 : 0)
                }

                VStack(spacing: 8) {
                    Text("BetweenUs")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(Theme.warmBrown)

                    Text("Made for two")
                        .font(.system(.title3, design: .serif))
                        .italic()
                        .foregroundStyle(Theme.coral)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 10)
            }

            Spacer()

            Button {
                onContinue()
            } label: {
                Text("Get Started")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Theme.coral, in: .rect(cornerRadius: 16))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 20)
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                appeared = true
            }
        }
    }
}
