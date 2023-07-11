import ReccoHeadless

extension ReccoTopic {
    var displayName: String {
        switch self {
        case .physicalActivity:
            return "recco_dashboard_alert_physical_activity_title".localized
        case .nutrition:
            return "recco_dashboard_alert_nutrition_title".localized
        case .mentalWellbeing:
            return "recco_dashboard_alert_mental_wellbeing_title".localized
        case .sleep:
            return "recco_dashboard_alert_sleep_title".localized
        }
    }
}
