import Foundation
import ReccoHeadless

final class OnboardingOutroViewModel: ObservableObject {
    private let meRepo: MeRepository
    private let nav: ReccoCoordinator
    private let logger: Logger

    @Published var isLoading = false
    @Published var meError: Error?

    init(
        meRepo: MeRepository,
        nav: ReccoCoordinator,
        logger: Logger
    ) {
        self.meRepo = meRepo
        self.nav = nav
        self.logger = logger
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
            logger.log(error)
            meError = error
        }
        isLoading = false
    }
}
