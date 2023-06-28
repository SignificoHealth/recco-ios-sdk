import ReccoHeadless
import Foundation
import Combine

final class SplashViewModel: ObservableObject {
    var cancellable: AnyCancellable?
    private let repo: MeRepo
    
    @Published var user: AppUser?
    
    init(
        repo: MeRepo
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
