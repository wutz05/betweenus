import SwiftUI

struct SendMessageOverlay: View {
    @Environment(AppDataStore.self) private var store
    @Binding var isPresented: Bool
    @State private var messageText: String = ""
    @State private var sent = false
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Send a note")
                                .font(.system(.title3, design: .rounded, weight: .bold))
                                .foregroundStyle(Theme.warmBrown)
                            Text("to \(store.coupleData.partner.name)")
                                .font(.system(.subheadline, design: .serif))
                                .italic()
                                .foregroundStyle(Theme.textSecondary)
                        }
                        Spacer()
                        Button { dismiss() } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundStyle(Theme.textTertiary)
                        }
                    }

                    if sent {
                        VStack(spacing: 12) {
                            Image(systemName: "heart.circle.fill")
                                .font(.system(size: 48))
                                .foregroundStyle(Theme.pink)
                                .symbolEffect(.bounce, value: sent)
                            Text("Sent with love!")
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(Theme.warmBrown)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .transition(.scale.combined(with: .opacity))
                    } else {
                        VStack(spacing: 16) {
                            TextField("Write something sweet...", text: $messageText, axis: .vertical)
                                .font(.system(.body, design: .serif))
                                .foregroundStyle(Color(.label))
                                .lineLimit(3...6)
                                .padding(14)
                                .background(Color(.tertiarySystemFill), in: .rect(cornerRadius: 14))
                                .focused($isFocused)

                            ScrollView(.horizontal) {
                                HStack(spacing: 8) {
                                    ForEach(quickMessages, id: \.self) { msg in
                                        Button {
                                            messageText = msg
                                        } label: {
                                            Text(msg)
                                                .font(.system(.caption, design: .rounded))
                                                .foregroundStyle(Theme.coral)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 7)
                                                .background(Theme.lightCoral, in: Capsule())
                                        }
                                    }
                                }
                            }
                            .contentMargins(.horizontal, 0)
                            .scrollIndicators(.hidden)

                            Button {
                                guard !messageText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
                                store.sendMessage(messageText)
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    sent = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                                    dismiss()
                                }
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "paperplane.fill")
                                    Text("Send")
                                }
                                .font(.system(.headline, design: .rounded))
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(
                                    messageText.trimmingCharacters(in: .whitespaces).isEmpty ? Theme.coral.opacity(0.4) : Theme.coral,
                                    in: .rect(cornerRadius: 14)
                                )
                            }
                            .disabled(messageText.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        .transition(.opacity)
                    }
                }
                .padding(20)
                .background(.regularMaterial, in: .rect(cornerRadius: 28))
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
            }
        }
        .onAppear { isFocused = true }
    }

    private func dismiss() {
        isFocused = false
        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            isPresented = false
        }
    }

    private let quickMessages: [String] = [
        "I miss you 💕",
        "Thinking of you ☁️",
        "Can't wait to see you 🥰",
        "You make me happy 🌸",
        "Love you! ❤️"
    ]
}
