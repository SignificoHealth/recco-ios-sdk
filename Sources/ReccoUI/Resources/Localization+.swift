//
//  Localization+.swift
//
//
//  Created by Adrián R on 24/6/22.
//

import Foundation
import SwiftUI

extension String {
    func loc(_ bundle: Bundle) -> String {
        NSLocalizedString(self, bundle: bundle, comment: "")
    }

    func loc(_ bundle: Bundle, _ args: CVarArg...) -> String {
        String(format: loc(bundle), args)
    }
}

extension Text {
    init(resource: String) {
        self.init(resource.localized)
    }
}

extension String {
    var localized: String {
        self.loc(.resourcesBundle)
    }

    func localized(_ args: CVarArg...) -> String {
        String(format: localized, args)
    }
}
