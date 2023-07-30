import XCTest
@testable import ReccoUI

final class PublicAPITest: XCTestCase {

    override class func setUp() {
        MockAssembly.assemble()
    }

    // MARK: - login

    func test_login_callsLoginAndGetMe() async throws {
        let mockAuthRepository = MockAssembly.mockAuthRepository
        let mockMeRepository = MockAssembly.mockMeRepository
        let userId = "userId"
        let loginExpectation = expectation(description: "login was not called")
        mockAuthRepository.expectations[.login] = loginExpectation
        mockAuthRepository.expectedClientUserId = userId
        let getMeExpectation = expectation(description: "getMe was not called")
        mockMeRepository.expectations[.getMe] = getMeExpectation

        try await ReccoUI.login(userId: userId)

        await fulfillment(of: [loginExpectation, getMeExpectation])
    }

    // MARK: - logout

    func test_logout_callsLogout() async throws {
        let mockAuthRepository = MockAssembly.mockAuthRepository
        let logoutExpectation = expectation(description: "login was not called")
        mockAuthRepository.expectations[.logout] = logoutExpectation

        try await ReccoUI.logout()

        await fulfillment(of: [logoutExpectation])
    }
}
