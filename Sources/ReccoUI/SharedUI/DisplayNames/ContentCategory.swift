//
//  File.swift
//  
//
//  Created by Adrián R on 1/2/24.
//

import Foundation
import ReccoHeadless

extension ContentCategory {
    var displayName: String {
        switch self {
        case .exercise:
            return "recco_category_exercise_name".localized
        case .meditation:
            return "recco_category_meditation_name".localized
        case .relaxation:
            return "recco_category_relaxation_name".localized
        }
    }
}
