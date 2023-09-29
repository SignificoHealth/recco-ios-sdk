@testable import ReccoHeadless
import XCTest

final class MockMetricRepository: MetricRepository {
    enum ExpectationType {
        case logEvent
    }
    
    var expectations: [ExpectationType: XCTestExpectation] = [:]
    var expectedEvent: AppUserMetricEvent?
    
    func log(event: AppUserMetricEvent) {
        expectations[.logEvent]?.fulfill()
        
        if let expectedEvent = expectedEvent {
            XCTAssertEqual(event, expectedEvent)
        }
    }
}
