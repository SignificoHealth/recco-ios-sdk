import Foundation
import ReccoHeadless

extension FeedSectionType {
    var displayName: String {
        switch self {
        case .physicalActivityRecommendations:
            return "feedSection.name.rec.physicalActivity".localized
        case .nutritionRecommendations:
            return "feedSection.name.rec.nutrition".localized
        case .mentalWellbeingRecommendations:
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
        case .mentalWellbeingExplore:
            return "feedSection.name.explore.physicalWellbeing".localized
        case .sleepExplore:
            return "feedSection.name.explore.sleep".localized
        case .startingRecommendations:
            return "feedSection.name.rec.start".localized
        }
    }
    
    var recName: String {
        switch self {
        case .physicalActivityRecommendations:
            return "feedSection.recName.physicalActivity".localized
        case .nutritionRecommendations:
            return "feedSection.recName.nutrition".localized
        case .mentalWellbeingRecommendations:
            return "feedSection.recName.physicalWellbeing".localized
        case .sleepRecommendations:
            return "feedSection.recName.sleep".localized
        default:
            fatalError()
        }
    }
    
    var description: String? {
        switch self {
        case .physicalActivityRecommendations:
            return "feedSection.description.rec.physicalActivity".localized
        case .nutritionRecommendations:
            return "feedSection.description.rec.nutrition".localized
        case .mentalWellbeingRecommendations:
            return "feedSection.description.rec.physicalWellbeing".localized
        case .sleepRecommendations:
            return "feedSection.description.rec.sleep".localized
        default:
            return nil
        }
    }
}
