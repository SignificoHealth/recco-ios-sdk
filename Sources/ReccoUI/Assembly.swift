import ReccoHeadless
import SwiftUI

final class UIAssembly: ReccoAssembly {
    init() {}
    func assemble(container: ReccoContainer) {
        container.register(type: ReccoCoordinator.self) { r in
            ReccoCoordinator(window: r.get())
        }
        
        container.register(type: DashboardViewModel.self) { r in
            DashboardViewModel(
                feedRepo: r.get(),
                recRepo: r.get(),
                nav: r.get()
            )
        }
        
        container.register(type: ArticleDetailViewModel.self) { (r: ReccoResolver, tuple: (ContentId, String, URL?, (ContentId) -> Void, (Bool) -> Void)) in
            ArticleDetailViewModel(
                loadedContent: tuple,
                articleRepo: r.get(),
                contentRepo: r.get(),
                nav: r.get()
            )
        }
        
        container.register(type: OnboardingOutroViewModel.self) { r in
            OnboardingOutroViewModel(
                meRepo: r.get(),
                nav: r.get()
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
        
        container.register(type: TopicQuestionnaireViewModel.self) { (r: ReccoResolver, tuple: (SFTopic, (Bool) -> Void)) in
            TopicQuestionnaireViewModel(
                topic: tuple.0,
                reloadSection: tuple.1,
                nav: r.get(),
                repo: r.get()
            )
        }
        
        container.register(type: OnboardingQuestionnaireViewModel.self) { r, next in
            OnboardingQuestionnaireViewModel(
                nextScreen: next,
                repo: r.get(),
                nav: r.get()
            )
        }
        
        container.register(type: BookmarksViewModel.self) { r in
            BookmarksViewModel(
                recRepo: r.get(),
                nav: r.get()
            )
        }
    }
}

import SwiftUI

func withAssembly<Content>(@ViewBuilder content: @escaping (ReccoResolver) -> Content) -> Assembling<Content> {
    Assembling(HeadlessAssembly(clientSecret: ""), UIAssembly(), content: content)
}
