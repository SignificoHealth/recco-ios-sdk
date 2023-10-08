import Combine
import Foundation
import ReccoHeadless
import SwiftUI

/**
 Configures Recco SDK given a clientSecret and a style (optional)
 - Parameter clientSecret: Credential required to identify and authenticate the application.
 - Parameter style: Provides the style configuration the application will use; the default is ReccoStyle.summer.
 */
public func initialize(
    clientSecret: String,
    style: ReccoStyle = .fresh,
    logger: @escaping (Error) -> Void = { error in
        #if DEBUG
            print(error)
        #endif
    }
) {
    assemble([
        ReccoHeadlessAssembly(clientSecret: clientSecret),
        ReccoUIAssembly(logger: Logger(log: logger)),
    ])

    let keychain: KeychainProxy = get()

    Api.initialize(
        clientSecret: clientSecret,
        baseUrl: "https://recco-api.significo.app",
        keychain: keychain
    )

    CurrentReccoStyle = style

    addLifecycleObserversForMetrics()
}

/**
 Performs login operation given a user identifier
 - Parameter userId: User to be consuming the SDK and to be creating its own experience.
 */
public func login(userId: String) async throws {
    let authRepository: AuthRepository
    let meRepository: MeRepository

    do {
        authRepository = try tget()
        meRepository = try tget()
    } catch {
        throw ReccoError.notInitialized
    }

    try await authRepository.login(clientUserId: userId)
    try await meRepository.getMe()
}

/**
 Performs logout operation
 */
public func logout() async throws {
    let authRepository: AuthRepository
    do {
        authRepository = try tget()
    } catch {
        throw ReccoError.notInitialized
    }
    try await authRepository.logout()
}

/**
 Root UIViewController for Recco's full experience journey.
 */
public func reccoRootViewController() -> UIViewController {
    UIHostingController(
        rootView: SplashView(
            viewModel: get()
        )
    )
}

/**
 Root View for Recco's full experience journey..
 */
public struct ReccoRootView: View {
    public init() {}

    public var body: some View {
        ToSwiftUI {
            reccoRootViewController()
        }
        .ignoresSafeArea()
    }
}

internal var cancellables = Set<AnyCancellable>()
internal func addLifecycleObserversForMetrics() {
    // Release previous publishers if called multiple times
    // This could happen during tests or if the SDK is initialized multiple times
    cancellables = Set<AnyCancellable>()

    let metricRepository: MetricRepository = get()

    // Emit when the host app enters foreground, it will emit once when the sdk is initialized during the start up of the app
    NotificationCenter.default
        .publisher(for: UIApplication.willEnterForegroundNotification)
        .sink { _ in
            metricRepository.log(event: AppUserMetricEvent(category: .userSession, action: .hostAppOpen))
        }
        .store(in: &cancellables)
}
