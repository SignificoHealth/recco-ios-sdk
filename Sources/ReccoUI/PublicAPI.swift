import Foundation
import ReccoHeadless
import SwiftUI

public func initialize(
    clientSecret: String,
    theme: ReccoTheme = .fresh
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

public func login(user: String) async throws {
    let authRepo: AuthRepository = get()
    let meRepo: MeRepo = get()
    
    try await authRepo.login(clientUserId: user)
    try await meRepo.getMe()
}

public func logout() async throws {
    let repo: AuthRepository = get()
    try await repo.logout()
}

public func sfRootViewController() -> UIViewController {
    UIHostingController(
        rootView: SplashView(
            viewModel: get()
        )
    )
}

public struct SFRootView: View {
    public init() {}
    
    public var body: some View {
        ToSwiftUI {
            sfRootViewController()
        }
        .ignoresSafeArea()
    }
}
