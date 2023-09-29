@testable import ReccoHeadless
@testable import ReccoUI
import XCTest

@MainActor
final class PublicAPITest: XCTestCase {
    // MARK: - initialize

    func test_initialize_registersDependenciesAndInitializesAPI() throws {
        MockAssembly.reset()
        let clientSecret = "clientSecret"
        let reccoStyle: ReccoStyle = .ocean

        XCTAssertThrowsError(try tget() as AuthRepository)
        XCTAssertThrowsError(try tget() as OnboardingViewModel)
        ReccoUI.initialize(clientSecret: clientSecret, style: reccoStyle)

        XCTAssertNoThrow(try tget() as AuthRepository)
        XCTAssertNoThrow(try tget() as OnboardingViewModel)
        XCTAssertEqual(BearerTokenHandler.clientSecret, "Bearer \(clientSecret)")
        XCTAssertEqual(OpenAPIClientAPI.basePath, "https://recco-api.significo.app")
        XCTAssertEqual(OpenAPIClientAPI.customHeaders["Accept-Language"], "en-US")
        XCTAssertEqual(OpenAPIClientAPI.customHeaders["Client-Platform"], "iOS")
    }

    // MARK: - login

    func test_login_whenCalledBeforeInitializeSDK_throwsError() async throws {
        MockAssembly.reset()
        do {
            try await ReccoUI.login(userId: "userId")
            XCTFail("Should have thrown an error")
        } catch {
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
        } catch {
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

    // MARK: - addLifecycleObserversForMetrics

    func test_addLifecycleObserversForMetrics_whenCalled_logsHostAppOpenEvent() async {
        MockAssembly.assemble()
        let mockMetricRepository = MockAssembly.mockMetricRepository

        let event = AppUserMetricEvent(category: .userSession, action: .hostAppOpen)
        let logEventExpectation = expectation(description: "log was not called")
        mockMetricRepository.expectations[.logEvent] = logEventExpectation
        mockMetricRepository.expectedEvent = event

        ReccoUI.addLifecycleObserversForMetrics()

        await fulfillment(of: [logEventExpectation], timeout: 1)
    }

    func test_addLifecycleObserversForMetrics_whenWillEnterForegroundNotificationIsEmitted_logsHostAppOpenEvent() async {
        MockAssembly.assemble()
        let mockMetricRepository = MockAssembly.mockMetricRepository
        ReccoUI.addLifecycleObserversForMetrics()

        let event = AppUserMetricEvent(category: .userSession, action: .hostAppOpen)
        let logEventExpectation = expectation(description: "log was not called")
        mockMetricRepository.expectations[.logEvent] = logEventExpectation
        mockMetricRepository.expectedEvent = event

        NotificationCenter.default.post(name: UIApplication.willEnterForegroundNotification, object: nil)

        await fulfillment(of: [logEventExpectation], timeout: 1)
    }

    func test_addLifecycleObserversForMetrics_whendidEnterBackgroundNotificationIsEmitted_doesNotlogsHostAppOpenEvent() async {
        MockAssembly.assemble()
        let mockMetricRepository = MockAssembly.mockMetricRepository
        ReccoUI.addLifecycleObserversForMetrics()

        let logEventExpectation = expectation(description: "log was called")
        logEventExpectation.isInverted = true
        mockMetricRepository.expectations[.logEvent] = logEventExpectation

        NotificationCenter.default.post(name: UIApplication.didEnterBackgroundNotification, object: nil)

        await fulfillment(of: [logEventExpectation], timeout: 1)
    }
}
