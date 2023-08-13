import Foundation
import ReccoHeadless
import SwiftUI

enum ReccoError: Error {
    case notInitialized
}

/**
 Configures Recco SDK given a clientSecret and a style (optional)
 - Parameters:
 - clietSecret: Credential required to identify and authenticate the application.
 - style: Provides the style configuration the application will use; the default is ReccoStyle.summer.
 */
public func initialize(
    clientSecret: String,
    style: ReccoStyle = .summer
) {
    assemble([
        ReccoHeadlessAssembly(clientSecret: clientSecret),
        ReccoUIAssembly()
    ])
    
    let keychain: KeychainProxy = get()
    
    Api.initialize(
        clientSecret: clientSecret,
        baseUrl: "http://api.sf-dev.significo.dev",
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
    do {
        let authRepository: AuthRepository = try tget()
        let meRepository: MeRepository = try tget()
        try await authRepository.login(clientUserId: userId)
        try await meRepository.getMe()
    } catch {
        throw ReccoError.notInitialized
    }
}

/**
 Performs logout operation
 */
public func logout() async throws {
    do {
        let repo: AuthRepository = try tget()
        try await repo.logout()
    } catch {
        throw ReccoError.notInitialized
    }
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
