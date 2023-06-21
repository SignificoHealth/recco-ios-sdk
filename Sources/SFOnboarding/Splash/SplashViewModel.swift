//
//  File.swift
//  
//
//  Created by Adrián R on 20/6/23.
//

import Foundation
import SFCore
import SFEntities
import SFRepo
import Combine

public final class SplashViewModel: ObservableObject {
    private let repo: MeRepo
    
    @Published var user: AppUser?
    
    var cancellable: AnyCancellable?
    init(
        repo: MeRepo
    ) {
        self.repo = repo

        bind()
    }
    
    private func bind() {
        repo
            .currentUser
            .receive(on: DispatchQueue.main)
            .assign(to: &$user)
    }
}
