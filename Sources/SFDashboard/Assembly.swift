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
        container.register(type: DashboardViewModel.self) { _ in
            DashboardViewModel()
        }
    }
}

#if DEBUG
import SwiftUI
func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(CoreAssembly(), DashboardAssembly(), content: content)
}
#endif
