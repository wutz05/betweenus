import SwiftUI

nonisolated struct ConfettiPiece: Identifiable, Sendable {
    let id = UUID()
    let color: Color
    let x: CGFloat
    let speed: Double
    let size: CGFloat
    let rotation: Double
    let delay: Double
    let horizontalDrift: CGFloat
}

struct ConfettiView: View {
    @State private var pieces: [ConfettiPiece] = []
    @State private var animate = false

    let colors: [Color] = [Theme.coral, Theme.pink, .yellow, .orange, .mint, .purple]

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(piece.color)
                        .frame(width: piece.size, height: piece.size * 0.6)
                        .rotationEffect(.degrees(animate ? piece.rotation + 360 : piece.rotation))
                        .position(
                            x: geo.size.width / 2 + piece.x + (animate ? piece.horizontalDrift : 0),
                            y: animate ? geo.size.height + 50 : -20
                        )
                        .opacity(animate ? 0 : 1)
                        .animation(
                            .easeIn(duration: piece.speed).delay(piece.delay),
                            value: animate
                        )
                }
            }
            .onAppear {
                pieces = (0..<80).map { _ in
                    ConfettiPiece(
                        color: colors.randomElement()!,
                        x: CGFloat.random(in: -geo.size.width / 2...geo.size.width / 2),
                        speed: Double.random(in: 2.0...4.0),
                        size: CGFloat.random(in: 6...14),
                        rotation: Double.random(in: 0...360),
                        delay: Double.random(in: 0...0.8),
                        horizontalDrift: CGFloat.random(in: -60...60)
                    )
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    animate = true
                }
            }
        }
        .allowsHitTesting(false)
    }
}
