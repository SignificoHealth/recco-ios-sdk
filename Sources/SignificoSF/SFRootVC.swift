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

public func initialize(clientSecret: String) {
    SFApi.initialize(
        clientSecret: clientSecret,
        baseUrl: "http://api.sf-dev.significo.dev"
    )
    
    SFCore.assemble([
        CoreAssembly(),
        DashboardAssembly()
    ])
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
