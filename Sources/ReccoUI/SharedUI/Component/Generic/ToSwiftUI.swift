import SwiftUI
import UIKit

struct ToSwiftUI: UIViewControllerRepresentable {
    let viewController: () -> UIViewController

    init(viewController: @escaping () -> UIViewController) {
        self.viewController = viewController
    }

    func makeUIViewController(context: Context) -> UIViewController {
        self.viewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
