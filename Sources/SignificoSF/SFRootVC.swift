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

public func initialize(clientSecret: String) {
    SFApi.initialize(
        clientSecret: clientSecret,
        baseUrl: "http://api.sf-dev.significo.dev"
    )
    
    SFCore.assemble([
        RepositoryAssembly(clientSecret: clientSecret),
        CoreAssembly(),
        DashboardAssembly()
    ])
}

public func login(user: String) async throws {
    let repo: AuthRepository = get()
    try await repo.login(clientUserId: user)
    SFApi.clientIdChanged(user)
}

public func logout() async throws {
    let repo: AuthRepository = get()
    try await repo.logout()
    SFApi.clientIdChanged(nil)
}

public struct SFRootView: View {
    public init() {}
    
    public var body: some View {
        DashboardView(viewModel: get())
    }
}

public var SFRootVC: UIViewController {
    UIHostingController(rootView: SFRootView())
}
