//
//  File.swift
//  
//
//  Created by Adrián R on 6/6/23.
//

import Foundation
import SFEntities

extension FeedSectionType {
    public var displayName: String {
        switch self {
        case .physicalActivityRecommendations:
            return "feedSection.name.rec.physicalActivity".localized
        case .nutritionRecommendations:
            return "feedSection.name.rec.nutrition".localized
        case .physicalWellbeingRecommendations:
            return "feedSection.name.rec.physicalWellbeing".localized
        case .sleepRecommendations:
            return "feedSection.name.rec.sleep".localized
        case .preferredRecommendations:
            return "feedSection.name.rec.preferred".localized
        case .mostPopular:
            return "feedSection.name.mostPopular".localized
        case .newContent:
            return "feedSection.name.newContent".localized
        case .physicalActivityExplore:
            return "feedSection.name.explore.physicalActivity".localized
        case .nutritionExplore:
            return "feedSection.name.explore.nutrition".localized
        case .physicalWellbeingExplore:
            return "feedSection.name.explore.physicalWellbeing".localized
        case .sleepExplore:
            return "feedSection.name.explore.sleep".localized
        case .startingRecommendations:
            return "feedSection.name.rec.start".localized
        }
    }
}
