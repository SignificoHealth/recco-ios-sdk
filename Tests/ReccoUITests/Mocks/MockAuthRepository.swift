import XCTest
@testable import ReccoHeadless
@testable import ReccoUI

final class MockAuthRepository: AuthRepository {

    enum ExpectationType {
        case login
        case logout
    }

    var expectedClientUserId = ""
    var expectations: [ExpectationType: XCTestExpectation] = [:]

    func login(clientUserId: String) async throws {
        XCTAssertEqual(expectedClientUserId, clientUserId)
        expectations[.login]?.fulfill()
    }

    func logout() async throws {
        expectations[.logout]?.fulfill()
    }
}
