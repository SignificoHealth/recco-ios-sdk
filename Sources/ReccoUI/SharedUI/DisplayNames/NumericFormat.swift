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
            return ("recco_questionnaire_numeric_label_cm".localized, nil)
        case (.imperialGB, .humanHeight), (.imperialUS, .humanHeight):
            return ("recco_questionnaire_numeric_label_ft".localized, "recco_questionnaire_numeric_label_in".localized)
        case (.metric, .humanWeight):
            return ("recco_questionnaire_numeric_label_kg".localized, nil)
        case (.imperialUS, .humanWeight):
            return ("recco_questionnaire_numeric_label_lb".localized, nil)
        case (.imperialGB, .humanWeight):
            return ("recco_questionnaire_numeric_label_st".localized, nil)
        case (_, .integer):
            return nil
        case (_, .decimal):
            return nil
        }
    }
}
