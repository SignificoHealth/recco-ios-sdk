//
//  File.swift
//  
//
//  Created by Adrián R on 20/6/23.
//

import Foundation
import UIKit
import SwiftUI
import SFQuestionnaire
import SFCore
import SFDashboard

enum Destination {
    case questionnaire
    case questionnaireOutro
}

public final class OnboardingCoordinator {
    private weak var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    private var navController: UINavigationController? {
        window?.topViewController()?.navigationController
    }
    
    func navigate(to destination: Destination) {
        switch destination {
        case .questionnaire:
            let viewModel: OnboardingQuestionnaireViewModel = get(
                argument: { [unowned self] in
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
        }
    }
}
