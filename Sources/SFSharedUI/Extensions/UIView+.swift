import UIKit

extension UIView {
    public var allSubviews: [UIView] {
        subviews + subviews.flatMap { $0.allSubviews }
    }
    
    public func pinEdges(
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
