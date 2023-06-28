import Foundation
import UIKit
import ReccoHeadless

extension NumericQuestionFormat {
    var keyboard: UIKeyboardType {
        switch self {
        case .humanHeight, .humanWeight, .decimal:
            return .decimalPad
        case .integer:
            return .numberPad
        }
    }
    
    func placeholder(_ locale: Locale) -> String {
        switch self {
        case .humanHeight:
            return "0"
        case .humanWeight:
            return "0\(locale.decimalSeparator ?? "")00"
        case .integer:
            return "0"
        case .decimal:
            return "0\(locale.decimalSeparator ?? "")00"
        }
    }
    
    func label(_ locale: Locale) -> (String, String?)? {
        switch (locale.getUnitSystem(), self) {
        case (.metric, .humanHeight):
            return ("questionnaire.numeric.label.cm".localized, nil)
        case (.imperialGB, .humanHeight), (.imperialUS, .humanHeight):
            return ("questionnaire.numeric.label.feet".localized, "questionnaire.numeric.label.inches".localized)

        case (.metric, .humanWeight):
            return ("questionnaire.numeric.label.kg".localized, nil)
        case (.imperialUS, .humanWeight):
            return ("questionnaire.numeric.label.lb".localized, nil)
        case (.imperialGB, .humanWeight):
            return ("questionnaire.numeric.label.stones".localized, nil)
        case (_, .integer):
            return nil
        case (_, .decimal):
            return nil
        }
    }
}
