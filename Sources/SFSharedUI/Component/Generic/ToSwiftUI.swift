import SwiftUI
import UIKit

public struct ToSwiftUI: UIViewControllerRepresentable {
  let viewController: () -> UIViewController

  public init(
    viewController: @escaping () -> UIViewController
  ) {
    self.viewController = viewController
  }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    self.viewController()
  }
  
  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
  }
}
