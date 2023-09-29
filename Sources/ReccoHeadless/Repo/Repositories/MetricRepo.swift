import Foundation

public protocol MetricRepository {
    func log(event: AppUserMetricEvent)
}

final class LiveMetricRepository: MetricRepository {
    private let keychain: KeychainProxy

    init(keychain: KeychainProxy) {
        self.keychain = keychain
    }

    func log(event: AppUserMetricEvent) {
        guard keychain.read(account: KeychainKey.clientUserId.rawValue) != nil else { return }

        Task {
            do {
                try await MetricAPI.logEvent(appUserMetricEventDTO: .init(entity: event))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
