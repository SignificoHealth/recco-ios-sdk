//
//  File.swift
//  
//
//  Created by Adrián R on 1/6/23.
//

import Foundation
import SFCore

public final class RepositoryAssembly: SFAssembly {
    private let clientSecret: String
    public init(clientSecret: String) {
        self.clientSecret = clientSecret
    }
    
    public func assemble(container: SFContainer) {
        container.register(type: AuthRepository.self) { [clientSecret] r in
            LiveAuthRepository(
                keychain: r.get(),
                clientSecret: clientSecret
            )
        }
    }
}
