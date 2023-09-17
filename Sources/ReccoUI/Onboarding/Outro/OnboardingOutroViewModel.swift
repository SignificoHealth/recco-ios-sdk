import Foundation
import ReccoHeadless

final class OnboardingOutroViewModel: ObservableObject {
    private let meRepo: MeRepository
    private let nav: ReccoCoordinator
    
    @Published var isLoading = false
    @Published var meError: Error?

    init(
        meRepo: MeRepository,
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
