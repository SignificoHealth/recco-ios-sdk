import Foundation
import ReccoHeadless

final class OnboardingOutroViewModel: ObservableObject {
    private let meRepo: MeRepo
    private let nav: ReccoCoordinator
    
    @Published var isLoading: Bool = false
    @Published var meError: Error?

    init(
        meRepo: MeRepo,
        nav: ReccoCoordinator
    ) {
        self.meRepo = meRepo
        self.nav = nav
    }
    
    func close() {
        nav.navigate(to: .dismiss)
    }

    @MainActor
    func goToDashboardPressed() async {
        isLoading = true
        do {
            try await meRepo.getMe()
        } catch {
            meError = error
        }
        isLoading = false
    }
}
