@testable import ReccoHeadless
@testable import ReccoUI

final class MockAssembly {
    static var mockAuthRepository = MockAuthRepository()
    static var mockMeRepository = MockMeRepository()
    static var mockMetricRepository = MockMetricRepository()

    private static let container = ReccoSharedContainer.shared

    static func assemble(didLog: @escaping () -> Void = {}) {
        // Reset dependencies
        mockAuthRepository = MockAuthRepository()
        mockMeRepository = MockMeRepository()
        mockMetricRepository = MockMetricRepository()

        // Register dependencies
        container.register(type: AuthRepository.self, service: { _ in mockAuthRepository })
        container.register(type: MeRepository.self, service: { _ in mockMeRepository })
        container.register(type: MetricRepository.self, service: { _ in mockMetricRepository })
        container.register(type: Logger.self, service: { _ in Logger { _ in didLog() } })
    }

    static func reset() {
        container.reset()
    }
}
