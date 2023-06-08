import SFEntities
import SFSharedUI
import SFArticle
import UIKit
import SwiftUI
import SFCore

enum Destination {
    case article(id: ContentId, headline: String, imageUrl: URL?)
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
        case .article(id: let id, headline: let headline, imageUrl: let imageUrl):
            navController?.pushViewController(
                UIHostingController(rootView: ArticleDetailView(viewModel: get(argument:(id, headline, imageUrl)))),
                animated: true
            )
        }
    }
}
