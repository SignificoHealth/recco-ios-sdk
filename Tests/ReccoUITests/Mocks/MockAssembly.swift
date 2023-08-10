@testable import ReccoHeadless

final class MockAssembly {

    static var mockAuthRepository = MockAuthRepository()
    static var mockMeRepository = MockMeRepository()

    private static let container = ReccoSharedContainer.shared

    static func assemble() {
        // Reset dependencies
        mockAuthRepository = MockAuthRepository()
        mockMeRepository = MockMeRepository()

        // Register dependencies
        container.register(type: AuthRepository.self, service: { _ in mockAuthRepository })
        container.register(type: MeRepository.self, service: { _ in mockMeRepository})
    }
}
