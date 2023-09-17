import Combine
import Foundation
import ReccoHeadless

final class SplashViewModel: ObservableObject {
    var cancellable: AnyCancellable?
    private let repo: MeRepository
    
    @Published var user: AppUser?
    
    init(
        repo: MeRepository
    ) {
        self.repo = repo
        bind()
    }
    
    private func bind() {
        repo
            .currentUser
            .receive(on: DispatchQueue.main)
            .assign(to: &$user)
    }
}
