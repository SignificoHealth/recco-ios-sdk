import XCTest
@testable import ReccoHeadless

final class MockAuthRepository: AuthRepository {

    enum ExpectationType {
        case login
        case logout
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedClientUserId = ""

    func login(clientUserId: String) async throws {
        expectations[.login]?.fulfill()
        XCTAssertEqual(expectedClientUserId, clientUserId)
    }

    func logout() async throws {
        expectations[.logout]?.fulfill()
    }
}
