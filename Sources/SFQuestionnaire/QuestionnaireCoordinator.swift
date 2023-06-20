//
//  File.swift
//  
//
//  Created by Adrián R on 19/6/23.
//

import Foundation
import UIKit

enum Destination {
    case back
}

public final class QuestionnaireCoordinator {
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
        }
    }
}
