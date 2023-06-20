//
//  File.swift
//  
//
//  Created by Adrián R on 20/6/23.
//

import Foundation
import SFCore
import SFEntities

public final class SplashViewModel: ObservableObject {
    @Published var user: AppUser?
    @Published var error: Error?

    init(
        keychain: KeychainProxy
    ) {
        do {
            self.user = try keychain.read(key: .currentUser)
        } catch {
            self.error = error
        }
    }
}
