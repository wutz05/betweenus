import SwiftUI

struct NameEntryStepView: View {
    @Environment(AppDataStore.self) private var store
    @State private var myName: String = ""
    @State private var partnerName: String = ""
    @State private var appeared = false
    @FocusState private var focusedField: Field?
    let onContinue: () -> Void

    private enum Field { case myName, partnerName }

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 12) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(Theme.coral)

                Text("What are your names?")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .foregroundStyle(Theme.warmBrown)
            }
            .opacity(appeared ? 1 : 0)

            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Your name")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                    TextField("Your first name", text: $myName)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color(.label))
                        .textContentType(.givenName)
                        .focused($focusedField, equals: .myName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .partnerName }
                        .padding(14)
                        .background(Color(.systemBackground), in: .rect(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("Partner's name")
                        .font(.caption)
                        .foregroundStyle(Theme.textSecondary)
                    TextField("Their first name", text: $partnerName)
                        .font(.system(.body, design: .rounded))
                        .foregroundStyle(Color(.label))
                        .textContentType(.givenName)
                        .focused($focusedField, equals: .partnerName)
                        .submitLabel(.done)
                        .padding(14)
                        .background(Color(.systemBackground), in: .rect(cornerRadius: 12))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                }
            }
            .padding(.horizontal, 24)
            .opacity(appeared ? 1 : 0)

            Spacer()

            Button {
                store.coupleData.me.name = myName.trimmingCharacters(in: .whitespaces)
                store.coupleData.partner.name = partnerName.trimmingCharacters(in: .whitespaces)
                onContinue()
            } label: {
                Text("Continue")
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        isValid ? Theme.coral : Theme.coral.opacity(0.4),
                        in: .rect(cornerRadius: 16)
                    )
            }
            .disabled(!isValid)
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
            focusedField = .myName
        }
    }

    private var isValid: Bool {
        !myName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !partnerName.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
