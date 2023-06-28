//
//  File.swift
//  
//
//  Created by Adrián R on 24/6/22.
//

import Foundation
import SwiftUI

extension String {
    func loc(_ bundle: Bundle) -> String {
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }

    func loc(_ bundle: Bundle, _ args: CVarArg...) -> String {
        return String(format: loc(bundle), args)
    }

    func loc(_ bundle: Bundle, arguments: [CVarArg]) -> String {
        return String(format: loc(bundle), arguments: addMissingArguments(bundle, arguments: arguments))
    }

    // MARK: - Private

    private func addMissingArguments(_ bundle: Bundle, arguments: [CVarArg]) -> [CVarArg] {
        var arguments = arguments
        let argumentsCount = arguments.count
        let expectedArgumentsCount = loc(bundle).numberOfOccurrencesOf(string: "%@")
        for i in 0...expectedArgumentsCount where i >= argumentsCount {
            arguments.append("core.missingArgument".loc(.module))
        }
        return arguments
    }

    private func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy: string).count - 1
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
        return String(format: localized, args)
    }
    
    func localized(arguments: [CVarArg]) -> String {
        return String(format: loc(.resourcesBundle), arguments: addMissingArguments(.resourcesBundle, arguments: arguments))
    }
}
