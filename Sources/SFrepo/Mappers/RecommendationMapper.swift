import Foundation
import SFApi
import SFEntities

extension ContentId {
    init(dto: ContentIdDTO) {
        self.init(itemId: dto.itemId, catalogId: dto.catalogId)
    }
}

extension ContentType {
    init(dto: AppUserRecommendationDTO.TypeDTO) {
        switch dto {
        case .articles:
            self = .articles
        }
    }
}

extension ContentRating {
    init(dto: AppUserRecommendationDTO.RatingDTO) {
        switch dto {
        case .like:
            self = .like
        case .dislike:
            self = .dislike
        case .notRated:
            self = .notRated
        }
    }
}

extension ContentStatus {
    init(dto: AppUserRecommendationDTO.StatusDTO) {
        switch dto {
        case .noInteraction:
            self = .noInteraction
        case .viewed:
            self = .viewed
        }
    }
}

extension AppUserRecommendation {
    init(dto: AppUserRecommendationDTO) {
        self.init(
            id: .init(dto: dto.id),
            type: .init(dto: dto.type),
            rating: .init(dto: dto.rating),
            status: .init(dto: dto.status),
            headline: dto.headline,
            lead: dto.lead,
            imageUrl: dto.imageUrl.flatMap { URL(string: $0) }
        )
    }
}
