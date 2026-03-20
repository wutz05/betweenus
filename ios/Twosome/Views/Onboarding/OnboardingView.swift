import SwiftUI

enum OnboardingStep: Int, CaseIterable {
    case welcome
    case createOrJoin
    case yourName
    case anniversaryDate
    case birthdays
    case distance
    case profilePhoto
    case done
}

struct OnboardingView: View {
    @Environment(AppDataStore.self) private var store
    @State private var step: OnboardingStep = .welcome
    @State private var partnerCode: String = ""
    @State private var isCreating: Bool = true

    var body: some View {
        ZStack {
            Theme.cream.ignoresSafeArea()

            switch step {
            case .welcome:
                WelcomeStepView(onContinue: { withAnimation(.spring(response: 0.5)) { step = .createOrJoin } })
            case .createOrJoin:
                CreateOrJoinStepView(
                    isCreating: $isCreating,
                    partnerCode: $partnerCode,
                    onContinue: {
                        if isCreating {
                            store.coupleData.inviteCode = store.generateInviteCode()
                        }
                        withAnimation(.spring(response: 0.5)) { step = .yourName }
                    }
                )
            case .yourName:
                NameEntryStepView(onContinue: { withAnimation(.spring(response: 0.5)) { step = .anniversaryDate } })
            case .anniversaryDate:
                AnniversaryStepView(onContinue: { withAnimation(.spring(response: 0.5)) { step = .birthdays } })
            case .birthdays:
                BirthdaysStepView(onContinue: { withAnimation(.spring(response: 0.5)) { step = .distance } })
            case .distance:
                DistanceStepView(onContinue: { withAnimation(.spring(response: 0.5)) { step = .profilePhoto } })
            case .profilePhoto:
                ProfilePhotoStepView(onContinue: { withAnimation(.spring(response: 0.5)) { step = .done } })
            case .done:
                ConnectedStepView(onFinish: { store.completeOnboarding() })
            }
        }
    }
}
