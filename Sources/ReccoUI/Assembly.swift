import ReccoHeadless
import SwiftUI

final class ReccoUIAssembly: ReccoAssembly {
    let logger: Logger
    
    init(
        logger: Logger = Logger { _ in }
    ) {
        self.logger = logger
    }
    
    func assemble(container: ReccoContainer) {
        container.register(
            type: Logger.self,
            singleton: true
        ) { [logger] _ in
            logger
        }
        
        container.register(type: ReccoCoordinator.self) { r in
            DefaultReccoCoordinator(window: r.get())
        }
        
        container.register(type: DashboardViewModel.self) { r in
            DashboardViewModel(
                feedRepo: r.get(),
                recRepo: r.get(),
                nav: r.get(),
                logger: r.get()
            )
        }
        
        container.register(type: ArticleDetailViewModel.self) { (r: ReccoResolver, tuple: (ContentId, String, URL?, (ContentId) -> Void, (Bool) -> Void)) in
            ArticleDetailViewModel(
                loadedContent: tuple,
                articleRepo: r.get(),
                contentRepo: r.get(),
                nav: r.get(),
                logger: r.get()
            )
        }
        
        container.register(type: OnboardingOutroViewModel.self) { r in
            OnboardingOutroViewModel(
                meRepo: r.get(),
                nav: r.get(),
                logger: r.get()
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
        
        container.register(type: TopicQuestionnaireViewModel.self) { (r: ReccoResolver, tuple: (ReccoTopic, (Bool) -> Void)) in
            TopicQuestionnaireViewModel(
                topic: tuple.0,
                reloadSection: tuple.1,
                repo: r.get(),
                nav: r.get(),
                logger: r.get()
            )
        }
        
        container.register(type: OnboardingQuestionnaireViewModel.self) { r, next in
            OnboardingQuestionnaireViewModel(
                nextScreen: next,
                repo: r.get(),
                nav: r.get(),
                logger: r.get()
            )
        }
        
        container.register(type: BookmarksViewModel.self) { r in
            BookmarksViewModel(
                recRepo: r.get(),
                nav: r.get(),
                logger: r.get()
            )
        }
    }
}

import SwiftUI

func withAssembly<Content>(@ViewBuilder content: @escaping (ReccoResolver) -> Content) -> Assembling<Content> {
    Assembling(ReccoHeadlessAssembly(clientSecret: ""), ReccoUIAssembly(), content: content)
}
