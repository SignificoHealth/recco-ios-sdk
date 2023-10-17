import Combine
import Foundation
import ReccoHeadless

final class SplashViewModel: ObservableObject {
    var cancellable: AnyCancellable?
    private let meRepository: MeRepository
    private let metricRepository: MetricRepository

    @Published var user: AppUser?

    init(
        meRepository: MeRepository,
        metricRepository: MetricRepository
    ) {
        self.meRepository = meRepository
        self.metricRepository = metricRepository

        bind()
    }

    func onReccoSDKOpen() {
        metricRepository.log(event: AppUserMetricEvent(category: .userSession, action: .reccoSDKOpen))
    }

    // MARK: Private

    private func bind() {
        cancellable = meRepository
            .currentUser
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] newUser in
                self.user = newUser
                self.maybeChangeToBackOfficeStyle()
            }
    }

    private func maybeChangeToBackOfficeStyle() {
        if let backOfficeStyle = user?.appStyle {
            CurrentReccoStyle = ReccoStyle(from: backOfficeStyle)
        }
    }
}
