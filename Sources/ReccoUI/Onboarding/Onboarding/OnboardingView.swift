import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    
    var buttonText: String {
        viewModel.currentPage == viewModel.totalPages ? "recco_start".localized : "recco_next".localized
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(
                selection: $viewModel.currentPage.animation(.interactiveSpring())
            ) {
                ForEach(1...viewModel.totalPages, id: \.self) { pageN in
                    onboardingPage(pageN)
                        .tag(pageN)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack(spacing: .M) {
                ReccoButtonView(
                    text: buttonText,
                    action: {
                        withAnimation(.interactiveSpring()) {
                            viewModel.next()
                        }
                    }
                )
                
                indicator
            }
            .padding(.M)
        }
        .background(
            Color.reccoBackground.ignoresSafeArea()
        )
        .overlay(
            Button(action: { viewModel.close() }, label: {
                Image(resource: "close_ic")
                    .foregroundColor(.reccoPrimary)
                    .padding(.vertical, .M)
                    .padding(.horizontal, .S)

            }),
            alignment: .topTrailing
        )
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private var indicator: some View {
        HStack(spacing: .XXS) {
            ForEach(1...viewModel.totalPages, id: \.self) { pageN in
                let selected = viewModel.currentPage == pageN
                RoundedRectangle(cornerRadius: 2)
                    .fill(selected ? Color.reccoAccent : Color.reccoPrimary20)
                    .frame(width: 34, height: 4)
            }
        }
    }
    
    @ViewBuilder
    private func onboardingPage(_ n: Int) -> some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: .L) {
                    ZStack(alignment: .bottom) {
                        Color.reccoAccent20
                        Image(resource: "onboarding_image_\(n)")
                            .resizable()
                            .scaledToFit()
                            .frame(height: proxy.size.height * 0.4)
                    }
                    .frame(height: proxy.size.height * 0.45)
                    
                    VStack(spacing: .M) {
                        Text("recco_onboarding_page\(n)_title".localized)
                            .h1()
                        
                        Text("recco_onboarding_page\(n)_body".localized)
                            .body2()
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, .M)
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        withAssembly { r in
            OnboardingView(viewModel: r.get())
        }
    }
}
