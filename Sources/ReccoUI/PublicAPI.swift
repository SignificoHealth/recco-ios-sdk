import Foundation
import ReccoHeadless
import SwiftUI

/**
 Configures Recco SDK given a clientSecret and a theme (optional)
 - Parameters:
    - clietSecret: Credential required to identify and authenticate the application.
    - theme: Provides the style configuration the application will use; the default is ReccoTheme.summer.
 */
public func initialize(
    clientSecret: String,
    theme: ReccoTheme = .summer
) {
    assemble([
        HeadlessAssembly(clientSecret: clientSecret),
        UIAssembly()
    ])
    
    let keychain: KeychainProxy = get()
    
    Api.initialize(
        clientSecret: clientSecret,
        baseUrl: "http://api.sf-dev.significo.dev",
        keychain: keychain
    )
    
    Theme = theme
}

/**
 Performs login operation given a user identifier
 - Parameters:
    - userId: User to be consuming the SDK and to be creating its own experience.
 */
public func login(userId: String) async throws {
    try await login(userId: userId, authRepository: get(), meRepository: get())
}

func login(userId: String, authRepository: AuthRepository, meRepository: MeRepo) async throws {
    try await authRepository.login(clientUserId: userId)
    try await meRepository.getMe()
}

/**
 Performs logout operation
 */
public func logout() async throws {
    let repo: AuthRepository = get()
    try await repo.logout()
}


/**
 Root UIViewController for Recco's full experience journey.
 */
public func sfRootViewController() -> UIViewController {
    UIHostingController(
        rootView: SplashView(
            viewModel: get()
        )
    )
}

/**
 Root View for Recco's full experience journey..
 */
public struct SFRootView: View {
    public init() {}
    
    public var body: some View {
        ToSwiftUI {
            sfRootViewController()
        }
        .ignoresSafeArea()
    }
}
