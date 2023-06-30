import SwiftUI

struct OnboardingOutroView: View {
    @StateObject var viewModel: OnboardingOutroViewModel
    
    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: .S) {
                ScrollView {
                    VStack(spacing: .L) {
                        ZStack(alignment: .bottom) {
                            Color.reccoAccent20
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
                
                ReccoButtonView(
                    text: "onboarding.outro.button".localized,
                    isLoading: viewModel.isLoading,
                    action: viewModel.goToDashboardPressed
                )
                .padding(.M)
            }
        }
        .background(Color.reccoBackground.ignoresSafeArea())
        .overlay(
            Button(action: { viewModel.close() }, label: {
                Image(resource: "close_ic")
                    .foregroundColor(.reccoPrimary)
                    .padding(.vertical, .M)
                    .padding(.horizontal, .S)

            }),
            alignment: .topTrailing
        )
        .reccoNotification(error: $viewModel.meError)
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