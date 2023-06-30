//
//  File.swift
//  
//
//  Created by Adrián R on 19/6/23.
//

import Foundation
import UIKit
import SwiftUI
import ReccoHeadless

enum Destination {
    case back
    case onboardingQuestionnaire
    case questionnaireOutro
    case article(id: ContentId, headline: String, imageUrl: URL?, seenContent: (ContentId) -> Void)
    case questionnaire(SFTopic, (Bool) -> Void)
    case bookmarks
    case dismiss
}

final class ReccoCoordinator {
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    private var navController: UINavigationController? {
        window?.topViewController()?.navigationController
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .back:
            navController?.popViewController(animated: true)
        case .onboardingQuestionnaire:
            let viewModel: OnboardingQuestionnaireViewModel = get(
                argument: { [unowned self] (_: Bool) in
                    navigate(to: .questionnaireOutro)
                }
            )
            
            let vc = UIHostingController(
                rootView: QuestionnaireView(
                    viewModel: viewModel,
                    navTitle: "onboarding.navTitle".localized
                )
            )
            
            navController?.pushViewController(
                vc,
                animated: true
            )
            
        case .questionnaireOutro:
            let vc = UIHostingController(
                rootView: OnboardingOutroView(
                    viewModel: get()
                )
            )
            
            navController?.pushViewController(
                vc,
                animated: true
            )
            
        case let .article(id, headline, imageUrl, seenContent):
            navController?.pushViewController(
                UIHostingController(rootView: ArticleDetailView(viewModel: get(argument:(id, headline, imageUrl, seenContent)))),
                animated: true
            )
            
        case let .questionnaire(topic, unlocked):
            let viewModel: TopicQuestionnaireViewModel = get(argument: (topic, unlocked))
            navController?.pushViewController(
                UIHostingController(rootView: QuestionnaireView(viewModel: viewModel, navTitle: topic.displayName)),
                animated: true
            )
        case .bookmarks:
            let viewModel: BookmarksViewModel = get()
            navController?.pushViewController(UIHostingController(rootView: BookmarksView(viewModel: viewModel)), animated: true)
            
        case .dismiss:
            window?.topViewController()?.dismiss(animated: true)
        }
    }
}
