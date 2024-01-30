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
            fatalError("Invalid recName")
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

extension ContentType {
    var iconName: String {
        switch self {
        case .articles:
            "article_content_ic"
        case .questionnaire:
            fatalError("Should never happen")
        case .audio:
            "audio_content_ic"
        case .video:
            "video_content_ic"
        }
    }

    var caption: String {
        switch self {
        case .articles:
            "recco_card_read".localized
        case .questionnaire:
            fatalError("Should never happen")
        case .audio:
            "recco_card_audio".localized
        case .video:
            "recco_card_video".localized
        }
    }
}

func displayDuration(seconds: Int) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = .minute
    let components = DateComponents(second: seconds)
    return formatter.string(from: components)!
}
