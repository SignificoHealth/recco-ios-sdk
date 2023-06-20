import SwiftUI
import UIKit

public final class SFNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        navigationItem.backButtonDisplayMode = .minimal
        
        let navAppearance = createNavAppearance()
        navigationBar.standardAppearance = navAppearance
        navigationBar.scrollEdgeAppearance = navAppearance
        navigationBar.compactAppearance = navAppearance
        
        if #available(iOS 15.0, *) {
            navigationBar.compactScrollEdgeAppearance = navAppearance
        }
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }

    // To make it works also with ScrollView but not simultaneously
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backButtonDisplayMode = .minimal
    }
}

func createNavAppearance() -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()
    let tint = UIColor.sfPrimary
        
    appearance.titleTextAttributes = [
        .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
        .foregroundColor: tint
    ]
    
    appearance.largeTitleTextAttributes = [
        .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
        .foregroundColor: tint
    ]

    appearance.backgroundColor = .sfBackground
    appearance.backgroundEffect = .none
    appearance.shadowColor = .clear
    
    let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
    buttonAppearance.normal.titleTextAttributes = [.foregroundColor: tint]
    appearance.buttonAppearance = buttonAppearance
    
    let image = UIImage(resource: "chevron_back")?
        .withTintColor(.sfPrimary, renderingMode: .alwaysOriginal)
    appearance.setBackIndicatorImage(image, transitionMaskImage: image)
    
    return appearance
}
