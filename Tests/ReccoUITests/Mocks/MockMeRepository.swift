import XCTest
import Combine
@testable import ReccoHeadless
@testable import ReccoUI

final class MockMeRepository: MeRepo {

    enum ExpectationType {
        case getMe
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    let _currentUser: CurrentValueSubject<AppUser?, Never> = .init(.none)

    public var currentUser: AnyPublisher<AppUser?, Never> {
        _currentUser.eraseToAnyPublisher()
    }

    func getMe() async throws {
        expectations[.getMe]?.fulfill()
    }
}
