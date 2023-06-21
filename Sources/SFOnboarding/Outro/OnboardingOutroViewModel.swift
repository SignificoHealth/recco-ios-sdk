//
//  File.swift
//  
//
//  Created by Adrián R on 21/6/23.
//

import Foundation
import SFRepo

final class OnboardingOutroViewModel: ObservableObject {
    private let meRepo: MeRepo
    
    @Published var isLoading: Bool = false
    @Published var meError: Error?

    init(meRepo: MeRepo) {
        self.meRepo = meRepo
    }
    
    func goToDashboardPressed() {
        Task { @MainActor in
            isLoading = true
            do {
                try await meRepo.getMe()
            } catch {
                meError = error
            }
            isLoading = false
        }
    }
}
