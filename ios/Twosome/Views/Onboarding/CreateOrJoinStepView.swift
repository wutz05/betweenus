import SwiftUI

struct CreateOrJoinStepView: View {
    @Binding var isCreating: Bool
    @Binding var partnerCode: String
    let onContinue: () -> Void
    @State private var appeared = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "link.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Theme.coral)
                    .symbolEffect(.bounce, value: appeared)

                Text("Connect with your partner")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)

                Text("Start a new couple or join your partner's invite")
                    .font(.subheadline)
                    .foregroundStyle(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .opacity(appeared ? 1 : 0)

            VStack(spacing: 16) {
                Button {
                    withAnimation(.spring) { isCreating = true }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Create a couple")
                                .font(.system(.headline, design: .rounded))
                            Text("Generate an invite code for your partner")
                                .font(.caption)
                                .foregroundStyle(isCreating ? .white.opacity(0.8) : Theme.textSecondary)
                        }
                        Spacer()
                        if isCreating {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .padding(16)
                    .foregroundStyle(isCreating ? .white : Theme.warmBrown)
                    .background(isCreating ? Theme.coral : Theme.cardBackground, in: .rect(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isCreating ? Color.clear : Theme.cardBorder, lineWidth: 1)
                    )
                }

                Button {
                    withAnimation(.spring) { isCreating = false }
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "person.badge.plus")
                            .font(.title3)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Join your partner")
                                .font(.system(.headline, design: .rounded))
                            Text("Enter the 6-digit code they shared")
                                .font(.caption)
                                .foregroundStyle(!isCreating ? .white.opacity(0.8) : Theme.textSecondary)
                        }
                        Spacer()
                        if !isCreating {
                            Image(systemName: "checkmark.circle.fill")
                        }
                    }
                    .padding(16)
                    .foregroundStyle(!isCreating ? .white : Theme.warmBrown)
                    .background(!isCreating ? Theme.coral : Theme.cardBackground, in: .rect(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(!isCreating ? Color.clear : Theme.cardBorder, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 24)
            .opacity(appeared ? 1 : 0)

            if !isCreating {
                VStack(spacing: 8) {
                    Text("Partner's invite code")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                    TextField("ABC123", text: $partnerCode)
                        .font(.system(.title2, design: .monospaced, weight: .bold))
                        .foregroundStyle(Color(.label))
                        .multilineTextAlignment(.center)
                        .textInputAutocapitalization(.characters)
                        .padding(12)
                        .background(Color(.systemBackground), in: .rect(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                }
                .padding(.horizontal, 24)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Spacer()

            Button {
                onContinue()
            } label: {
                Text("Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        (!isCreating && partnerCode.count < 6) ? Theme.coral.opacity(0.4) : Theme.coral,
                        in: .rect(cornerRadius: 16)
                    )
            }
            .disabled(!isCreating && partnerCode.count < 6)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
        }
    }
}
