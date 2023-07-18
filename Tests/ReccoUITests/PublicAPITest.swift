import XCTest
@testable import ReccoUI

final class PublicAPITest: XCTestCase {

    override class func setUp() {
        MockAssembly.assemble()
    }

    func testLogin() async throws {
        let mockAuthRepository = MockAssembly.mockAuthRepository
        let mockMeRepository = MockAssembly.mockMeRepository
        let user = "user"
        let loginExpectation = expectation(description: "Login was not called")
        mockAuthRepository.expectations[.login] = loginExpectation
        mockAuthRepository.expectedClientUserId = user
        let getMeExpectation = expectation(description: "GetMe was not called")
        mockMeRepository.expectations[.getMe] = getMeExpectation

        try await ReccoUI.login(user: user)

        await fulfillment(of: [loginExpectation, getMeExpectation])
    }

    func testLogout() async throws {
        let mockAuthRepository = MockAssembly.mockAuthRepository
        let logoutExpectation = expectation(description: "Login was not called")
        mockAuthRepository.expectations[.logout] = logoutExpectation

        try await ReccoUI.logout()

        await fulfillment(of: [logoutExpectation])
    }
}
