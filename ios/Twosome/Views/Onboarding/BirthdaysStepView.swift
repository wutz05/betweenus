import SwiftUI

struct BirthdaysStepView: View {
    @Environment(AppDataStore.self) private var store
    @State private var myBirthday: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @State private var partnerBirthday: Date = Calendar.current.date(byAdding: .year, value: -25, to: Date()) ?? Date()
    @State private var appeared = false
    let onContinue: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Spacer().frame(height: 40)

                VStack(spacing: 12) {
                    Image(systemName: "gift.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(Theme.coral)

                    Text("When are your birthdays?")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(Theme.warmBrown)

                    Text("So we never forget to celebrate!")
                        .font(.subheadline)
                        .foregroundStyle(Theme.textSecondary)
                }
                .opacity(appeared ? 1 : 0)

                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your birthday")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Theme.warmBrown)
                        DatePicker("Your birthday", selection: $myBirthday, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .tint(Theme.coral)
                            .padding(12)
                            .background(Color(.systemBackground), in: .rect(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(store.coupleData.partner.name.isEmpty ? "Partner" : store.coupleData.partner.name)'s birthday")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(Theme.warmBrown)
                        DatePicker("Partner birthday", selection: $partnerBirthday, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .tint(Theme.coral)
                            .padding(12)
                            .background(Color(.systemBackground), in: .rect(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Theme.cardBorder, lineWidth: 1))
                    }
                }
                .padding(.horizontal, 24)
                .opacity(appeared ? 1 : 0)

                Spacer().frame(height: 40)

                Button {
                    store.coupleData.me.birthday = myBirthday
                    store.coupleData.partner.birthday = partnerBirthday
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
        }
        .scrollDismissesKeyboard(.interactively)
        .onAppear {
            withAnimation(.spring(response: 0.6).delay(0.1)) { appeared = true }
        }
    }
}
