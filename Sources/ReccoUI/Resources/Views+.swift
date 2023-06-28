import Foundation
import SwiftUI
import UIKit

extension Color {
    init(resource: String) {
        self.init(resource, bundle: .resourcesBundle)
    }
}

extension UIColor {
    convenience init?(resource: String) {
        self.init(named: resource, in: localBundle, compatibleWith: .current)
    }
}

extension Image {
    init(resource: String) {
        self.init(resource, bundle: localBundle)
    }
}

extension UIImage {
    convenience init?(resource: String) {
        self.init(named: resource, in: localBundle, with: nil)
    }
}
