import SFEntities
import SFSharedUI
import SFArticle
import UIKit
import SwiftUI
import SFCore

enum Destination {
    case article(id: ContentId, headline: String, imageUrl: URL?, seenContent: (ContentId) -> Void)
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
        }
    }
}
