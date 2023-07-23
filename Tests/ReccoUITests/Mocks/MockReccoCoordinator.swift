import XCTest
@testable import ReccoUI

final class MockRecoCoordinator: ReccoCoordinator {

    enum ExpectationType {
        case navigate
    }

    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedDestination: Destination?
    var lastDestination: Destination?

    func navigate(to destination: Destination) {
        expectations[.navigate]?.fulfill()
        if let expectedDestination = expectedDestination {
            XCTAssertEqual(expectedDestination, destination)
        }
        lastDestination = destination
    }
}
