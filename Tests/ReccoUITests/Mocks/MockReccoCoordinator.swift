import XCTest
@testable import ReccoUI

final class MockRecoCoordinator: ReccoCoordinator {

    enum ExpectationType {
        case navigate
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedDestination: Destination?

    func navigate(to destination: Destination) {
        XCTAssertEqual(expectedDestination, destination)
        expectations[.navigate]?.fulfill()
    }
}
