import SwiftUI
import SFSharedUI
import SFDashboard
import SFCore

public struct SplashView: View {
    @StateObject var viewModel: SplashViewModel
    
    public init(viewModel: SplashViewModel) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    
    private var noUser: Error {
        struct NoUser: Error {}
        return NoUser()
    }
    
    @ViewBuilder
    var content: some View {
        if let user = viewModel.user {
            if user.isOnboardingQuestionnaireCompleted {
                DashboardView(viewModel: get())
            } else {
                OnboardingView(viewModel: get())
            }
        } else {
            SFErrorView(error: .constant(noUser))
        }
    }
    
    @ViewBuilder
    public var body: some View {
        content
            .navigationBarHidden(true)
    }
}
