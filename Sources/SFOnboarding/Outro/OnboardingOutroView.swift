import SwiftUI
import SFSharedUI

struct OnboardingOutroView: View {
    @StateObject var viewModel: OnboardingOutroViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: .S) {
                ScrollView {
                    VStack(spacing: .L) {
                        ZStack(alignment: .bottom) {
                            Color.sfAccent20
                            Image(resource: "onboarding_image_3")
                                .resizable()
                                .scaledToFit()
                                .frame(height: proxy.size.height * 0.4)
                        }
                        .frame(height: proxy.size.height * 0.45)
                        
                        VStack(spacing: .M) {
                            Text("onboarding.outro.title".localized)
                                .h1()
                                .multilineTextAlignment(.center)

                            Text("onboarding.outro.description".localized)
                                .body2()
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal, .M)
                    }
                }
                
                SFButton(
                    text: "onboarding.outro.button".localized,
                    isLoading: viewModel.isLoading,
                    action: viewModel.goToDashboardPressed
                )
                .padding(.M)
            }
        }
        .sfNotification(error: $viewModel.meError)
        .navigationBarHidden(true)
    }
}

struct OnboardingOutroView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            OnboardingOutroView(viewModel: r.get())

        }
    }
}
