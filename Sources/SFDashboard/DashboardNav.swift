import SFEntities
import SFSharedUI
import SFArticle
import UIKit
import SwiftUI
import SFCore
import SFQuestionnaire

enum Destination {
    case article(id: ContentId, headline: String, imageUrl: URL?, seenContent: (ContentId) -> Void)
    case dismiss
    case questionnaire(SFTopic)
}

public final class DashboardCoordinator {
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    private var navController: UINavigationController? {
        window?.topViewController()?.navigationController
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case let .article(id, headline, imageUrl, seenContent):
            navController?.pushViewController(
                UIHostingController(rootView: ArticleDetailView(viewModel: get(argument:(id, headline, imageUrl, seenContent)))),
                animated: true
            )
            
        case let .questionnaire(topic):
            navController?.pushViewController(
                UIHostingController(rootView: QuestionnaireView(viewModel: get(argument: topic))),
                animated: true
            )
            
        case .dismiss:
            window?.topViewController()?.dismiss(animated: true)
        }
    }
}
