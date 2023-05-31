//
//  Color+.swift
//  
//
//  Created by Adrián R on 28/2/22.
//

import Foundation
import SwiftUI
import UIKit

extension Color {
    public init(resource: String) {
        self.init(resource, bundle: .resourcesBundle)
    }
}

extension UIColor {
    public convenience init?(resource: String) {
        self.init(named: resource, in: SFResources.localBundle, compatibleWith: .current)
    }
}
