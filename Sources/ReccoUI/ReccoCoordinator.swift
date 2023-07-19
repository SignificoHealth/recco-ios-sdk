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

enum Destination: Equatable {
    case back
    case onboardingQuestionnaire
    case questionnaireOutro
    case article(id: ContentId, headline: String, imageUrl: URL?, seenContent: (ContentId) -> Void, onBookmarkedChange: (Bool) -> Void)
    case questionnaire(ReccoTopic, (Bool) -> Void)
    case bookmarks
    case dismiss

    static func == (lhs: Destination, rhs: Destination) -> Bool {
        switch (lhs, rhs) {
        case (.back, .back),
            (.onboardingQuestionnaire, .onboardingQuestionnaire),
            (.questionnaireOutro, .questionnaireOutro),
            (.bookmarks, .bookmarks),
            (.dismiss, .dismiss):
            return true
        case (let .article(id1, headline1, imageUrl1, _, _), let .article(id2, headline2, imageUrl2, _, _)):
            return id1 == id2 && headline1 == headline2 && imageUrl1 == imageUrl2
        case (let .questionnaire(topic1, _), let .questionnaire(topic2, _)):
            return topic1 == topic2
        default:
            return false
        }
    }
}

protocol ReccoCoordinator {
    func navigate(to destination: Destination)
}

final class DefaultReccoCoordinator: ReccoCoordinator {
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
                    navTitle: "recco_questionnaire_about_you".localized
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
            
        case let .article(id, headline, imageUrl, seenContent, onBookmarkedChange):
            navController?.pushViewController(
                UIHostingController(rootView: ArticleDetailView(viewModel: get(argument:(id, headline, imageUrl, seenContent, onBookmarkedChange)))),
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
