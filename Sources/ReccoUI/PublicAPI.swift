import Foundation
import ReccoHeadless
import SwiftUI

enum ReccoError: Error {
    case notInitialized
}

/**
 Configures Recco SDK given a clientSecret and a style (optional)
 - Parameters:
    - clientSecret: Credential required to identify and authenticate the application.
    - style: Provides the style configuration the application will use; the default is ReccoStyle.summer.
 */
public func initialize(
    clientSecret: String,
    style: ReccoStyle = .fresh
) {
    assemble([
        ReccoHeadlessAssembly(clientSecret: clientSecret),
        ReccoUIAssembly(),
    ])

    let keychain: KeychainProxy = get()

    Api.initialize(
        clientSecret: clientSecret,
        baseUrl: "https://recco-api.significo.app",
        keychain: keychain
    )

    CurrentReccoStyle = style
}

/**
 Performs login operation given a user identifier
 - Parameters:
    - userId: User to be consuming the SDK and to be creating its own experience.
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
