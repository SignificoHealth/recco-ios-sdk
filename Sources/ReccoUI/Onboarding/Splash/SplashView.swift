import ReccoHeadless
import SwiftUI

struct SplashView: View {
    @StateObject var viewModel: SplashViewModel

    @Environment(\.scenePhase) private var scenePhase

    init(viewModel: SplashViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }

    private var noUser: Error {
        struct NoUser: Error {}
        return NoUser()
    }

    @State private var _user: AppUser?

    @ViewBuilder
    var content: some View {
        if let user = _user {
            if user.isOnboardingQuestionnaireCompleted {
                SFNavigationView {
                    DashboardView(viewModel: get())
                }
            } else {
                SFNavigationView {
                    OnboardingView(viewModel: get())
                }
            }
        } else {
            ReccoErrorView(error: .constant(noUser))
        }
    }

    var body: some View {
        content
            .transition(.opacity)
            .ignoresSafeArea()
            .onReceive(viewModel.$user) { newUser in
                if _user == nil {
                    _user = newUser
                } else {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        _user = newUser
                    }
                }
            }
            // First time the view is shown
            .onAppear(perform: {
                viewModel.onReccoSDKOpened()
            })
            // Every time the app comes from the background
            .onChange(of: scenePhase) { phase in
                if phase == .active {
                    viewModel.onReccoSDKOpened()
                }
            }
    }
}
