import ReccoHeadless

extension SFTopic {
    var displayName: String {
        switch self {
        case .physicalActivity:
            return "questionnaire.title.physicalActivity".localized
        case .nutrition:
            return "questionnaire.title.nutrition".localized
        case .mentalWellbeing:
            return "questionnaire.title.mentalHealth".localized
        case .sleep:
            return "questionnaire.title.sleep".localized
        }
    }
}
