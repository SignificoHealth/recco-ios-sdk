import XCTest
import Combine
@testable import ReccoHeadless

final class MockMeRepository: MeRepo {

    enum ExpectationType {
        case getMe
    }

    var _currentUser: CurrentValueSubject<AppUser?, Never> = .init(.none)

    var expectations: [ExpectationType: XCTestExpectation] = [:]

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
