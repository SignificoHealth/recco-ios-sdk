import XCTest
import Combine
@testable import ReccoHeadless

final class MockMeRepository: MeRepo {

    enum ExpectationType {
        case getMe
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var _currentUser: CurrentValueSubject<AppUser?, Never> = .init(.none)
    var getMeError: NSError?

    public var currentUser: AnyPublisher<AppUser?, Never> {
        _currentUser.eraseToAnyPublisher()
    }

    func getMe() async throws {
        expectations[.getMe]?.fulfill()

        guard let getMeError = getMeError else { return }
        throw getMeError
    }
}
