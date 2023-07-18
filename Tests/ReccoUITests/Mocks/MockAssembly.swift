@testable import ReccoHeadless

final class MockAssembly {

    static let mockAuthRepository = MockAuthRepository()
    static let mockMeRepository = MockMeRepository()

    private static let container = ReccoSharedContainer.shared

    static func assemble() {
        container.register(type: AuthRepository.self, service: { _ in self.mockAuthRepository })
        container.register(type: MeRepo.self, service: { _ in self.mockMeRepository})
    }
}
