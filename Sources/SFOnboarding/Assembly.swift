import Foundation
import SFCore
import SFRepo
import SFDashboard
import SFQuestionnaire

public final class OnboardingAssembly: SFAssembly {
    public init() {}
    
    public func assemble(container: SFContainer) {
        container.register(type: OnboardingCoordinator.self) { r in
            OnboardingCoordinator(window: r.get())
        }
        
        container.register(type: OnboardingOutroViewModel.self) { r in
            OnboardingOutroViewModel(
                meRepo: r.get()
            )
        }
        
        container.register(type: OnboardingViewModel.self) { r in
            OnboardingViewModel(nav: r.get())
        }
        
        container.register(type: SplashViewModel.self) { r in
            SplashViewModel(
                repo: r.get()
            )
        }
    }
}

import SwiftUI
import SFRepo
func withAssembly<Content>(@ViewBuilder content: @escaping (SFResolver) -> Content) -> Assembling<Content> {
    Assembling(RepositoryAssembly(clientSecret: ""), CoreAssembly(), OnboardingAssembly(), content: content)
}
