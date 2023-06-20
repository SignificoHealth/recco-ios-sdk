import Foundation

public final class OnboardingViewModel: ObservableObject {
    private let nav: OnboardingCoordinator
    
    init(nav: OnboardingCoordinator) {
        self.nav = nav
    }
    
    @Published var currentPage: Int = 1
    let totalPages = 3
    
    func next() {
        if currentPage == totalPages {
            goToQuestionnaire()
        } else {
            currentPage += 1
        }
    }
    
    // MARK: Private
    
    private func goToQuestionnaire() {
        nav.navigate(to: .questionnaire)
    }
}
