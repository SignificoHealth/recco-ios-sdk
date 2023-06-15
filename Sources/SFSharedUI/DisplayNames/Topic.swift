import SFEntities

extension SFTopic {
    public var displayName: String {
        switch self {
        case .physicalActivity:
            return "questionnaire.title.physicalActivity".localized
        case .nutrition:
            return "questionnaire.title.nutrition".localized
        case .physicalWellbeing:
            return "questionnaire.title.mentalHealth".localized
        case .sleep:
            return "questionnaire.title.sleep".localized
        }
    }
}
