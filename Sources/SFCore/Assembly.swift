//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation

public final class CoreAssembly: SFAssembly {
    public init() {}
    public func assemble(container: SFContainer) {
        container.register(type: Calendar.self) { _ in
            .current
        }
    }
}
