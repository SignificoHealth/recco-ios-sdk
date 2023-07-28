import Foundation
import ReccoHeadless

extension FeedSectionType {
    var displayName: String {
        switch self {
        case .physicalActivityRecommendations, .nutritionRecommendations, .mentalWellbeingRecommendations, .sleepRecommendations:
            return "recco_dashboard_recommended_for_you_topic".localized(recName)
        case .preferredRecommendations:
            return "recco_dashboard_you_may_also_like".localized
        case .mostPopular:
            return "recco_dashboard_trending".localized
        case .newContent:
            return "recco_dashboard_new_for_you".localized
        case .physicalActivityExplore, .nutritionExplore, .mentalWellbeingExplore, .sleepExplore:
            return "recco_dashboard_explore_topic".localized(recName)
        case .startingRecommendations:
            return "recco_dashboard_start_here".localized
        }
    }
    
    var recName: String {
        switch self {
        case .physicalActivityRecommendations, .physicalActivityExplore:
            return "recco_dashboard_alert_physical_activity_title".localized
        case .nutritionRecommendations, .nutritionExplore:
            return "recco_dashboard_alert_nutrition_title".localized
        case .mentalWellbeingRecommendations, .mentalWellbeingExplore:
            return "recco_dashboard_alert_mental_wellbeing_title".localized
        case .sleepRecommendations, .sleepExplore:
            return "recco_dashboard_alert_sleep_title".localized
        default:
            fatalError()
        }
    }
    
    var description: String? {
        switch self {
        case .physicalActivityRecommendations:
            return "recco_dashboard_alert_physical_activity_body".localized
        case .nutritionRecommendations:
            return "recco_dashboard_alert_nutrition_body".localized
        case .mentalWellbeingRecommendations:
            return "recco_dashboard_alert_mental_wellbeing_body".localized
        case .sleepRecommendations:
            return "recco_dashboard_alert_sleep_body".localized
        default:
            return nil
        }
    }
}
