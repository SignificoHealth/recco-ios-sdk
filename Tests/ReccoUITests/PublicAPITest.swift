import XCTest
@testable import ReccoUI

@MainActor
final class PublicAPITest: XCTestCase {

    // MARK: - login
    
    func test_login_whenCalledBeforeInitializeSDK_throwsError() async throws {
        MockAssembly.reset()
        do {
            try await ReccoUI.login(userId: "userId")
            XCTFail("Should have thrown an error")
        } catch (let error) {
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? ReccoError, ReccoError.notInitialized)
        }
    }

    func test_login_callsLoginAndGetMe() async throws {
        MockAssembly.assemble()
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

    func test_logout_whenCalledBeforeInitializeSDK_throwsError() async throws {
        MockAssembly.reset()
        do {
            try await ReccoUI.logout()
            XCTFail("Should have thrown an error")
        } catch (let error) {
            XCTAssertNotNil(error)
            XCTAssertEqual(error as? ReccoError, ReccoError.notInitialized)
        }
    }

    func test_logout_callsLogout() async throws {
        MockAssembly.assemble()
        let mockAuthRepository = MockAssembly.mockAuthRepository
        let logoutExpectation = expectation(description: "login was not called")
        mockAuthRepository.expectations[.logout] = logoutExpectation

        try await ReccoUI.logout()

        await fulfillment(of: [logoutExpectation])
    }
}
