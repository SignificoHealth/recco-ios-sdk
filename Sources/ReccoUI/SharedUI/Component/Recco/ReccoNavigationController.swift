import SwiftUI
import UIKit

final class ReccoNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    override func viewDidLoad() {
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

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }

    // To make it works also with ScrollView but not simultaneously
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.backButtonDisplayMode = .minimal
    }
}

func createNavAppearance() -> UINavigationBarAppearance {
    let appearance = UINavigationBarAppearance()
    let tint = UIColor.reccoPrimary

    appearance.titleTextAttributes = [
        .font: CurrentReccoStyle.font.uiFont(size: 17, weight: .semibold),
        .foregroundColor: tint,
    ]

    appearance.largeTitleTextAttributes = [
        .font: CurrentReccoStyle.font.uiFont(size: 17, weight: .semibold),
        .foregroundColor: tint,
    ]

    appearance.backgroundColor = .reccoBackground
    appearance.backgroundEffect = .none
    appearance.shadowColor = .clear

    let buttonAppearance = UIBarButtonItemAppearance(style: .plain)
    buttonAppearance.normal.titleTextAttributes = [.foregroundColor: tint]
    appearance.buttonAppearance = buttonAppearance

    let image = UIImage(resource: "chevron_back")?
        .withTintColor(.reccoPrimary, renderingMode: .alwaysOriginal)
    appearance.setBackIndicatorImage(image, transitionMaskImage: image)

    return appearance
}

struct SFNavigationView<Content: View>: View {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var content: () -> Content

    var body: some View {
        ToSwiftUI {
            ReccoNavigationController(
                rootViewController: UIHostingController(
                    rootView: content()
                )
            )
        }
        .background(
            Color.reccoBackground.ignoresSafeArea()
        )
    }
}
