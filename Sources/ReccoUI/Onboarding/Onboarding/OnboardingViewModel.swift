import Foundation
import ReccoHeadless

final class OnboardingViewModel: ObservableObject {
    private let nav: ReccoCoordinator
    
    init(nav: ReccoCoordinator) {
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
    
    func close() {
        nav.navigate(to: .dismiss)
    }
    
    // MARK: Private
    
    private func goToQuestionnaire() {
        nav.navigate(to: .onboardingQuestionnaire)
    }
}
