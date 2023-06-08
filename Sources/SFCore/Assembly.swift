//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation
import UIKit

public final class CoreAssembly: SFAssembly {
    public init() {}
    public func assemble(container: SFContainer) {
        container.register(type: Calendar.self) { _ in
            .current
        }
        
        container.register(type: Optional<UIWindow>.self) { _ in
            UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        }
        
        container.register(type: KeychainProxy.self) { _ in
            .standard
        }
    }
}
