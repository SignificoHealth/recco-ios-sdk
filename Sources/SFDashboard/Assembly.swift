//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation
import SFCore

public final class DashboardAssembly: SFAssembly {
    public init() {}
    public func assemble(container: SFContainer) {
        container.register(type: DashboardCoordinator.self) { r in
            DashboardCoordinator(window: r.get())
        }
        
        container.register(type: DashboardViewModel.self) { r in
            DashboardViewModel(
                feedRepo: r.get(),
                recRepo: r.get(),
                nav: r.get()
            )
        }
    }
}

import SwiftUI
import SFRepo
func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(RepositoryAssembly(clientSecret: ""), CoreAssembly(), DashboardAssembly(), content: content)
}
