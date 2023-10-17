import UIKit

extension UIView {
    var allSubviews: [UIView] {
        subviews + subviews.flatMap { $0.allSubviews }
    }

    func pinEdges(
        to view: UIView,
        margin: UIEdgeInsets = .zero,
        priority: Float = 1000
    ) {
        let bottom = bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -margin.bottom)
        bottom.isActive = true
        bottom.priority = .init(priority)

        let top = topAnchor.constraint(equalTo: view.topAnchor, constant: margin.top)
        top.isActive = true
        top.priority = .init(priority)

        let leading = leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin.left)
        leading.isActive = true
        leading.priority = .init(priority)

        let trailing = trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin.right)
        trailing.isActive = true
        trailing.priority = .init(priority)
    }
}

extension UIWindow {
    func topViewController() -> UIViewController? {
        var top = self.rootViewController
        while true {
            if let presented = top?.presentedViewController {
                top = presented
            } else if let nav = top as? UINavigationController {
                top = nav.visibleViewController
            } else if let tab = top as? UITabBarController {
                top = tab.selectedViewController
            } else if top?.children.count == 1 {
                top = top?.children.first
            } else {
                break
            }
        }
        return top
    }
}
