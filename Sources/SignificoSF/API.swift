//
//  File.swift
//  
//
//  Created by Adrián R on 25/5/23.
//

import SFDashboard
import Foundation
import SwiftUI
import SFCore
import SFApi
import SFRepo
import SFEntities
import SFSharedUI
import SFArticle
import SFQuestionnaire
import SFOnboarding

public func initialize(clientSecret: String) {
    SFApi.initialize(
        clientSecret: clientSecret,
        baseUrl: "http://api.sf-dev.significo.dev"
    )
    
    SFCore.assemble([
        RepositoryAssembly(clientSecret: clientSecret),
        CoreAssembly(),
        DashboardAssembly(),
        ArticleAssembly(),
        QuestionnaireAssembly(),
        OnboardingAssembly()
    ])
    
    let keychain: KeychainProxy = get()
    let appUser: AppUser? = try? keychain.read(key: .currentUser)
    appUser.map(\.id).map(SFApi.clientIdChanged)
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
