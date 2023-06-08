import Foundation
import SFApi
import SFEntities

extension AppUserRecommendation {
    init(dto: AppUserRecommendationDTO) throws {
        self.init(
            id: .init(dto: dto.id),
            type: try .init(dto: dto.type),
            rating: try .init(dto: dto.rating),
            status: try .init(dto: dto.status),
            headline: dto.headline,
            lead: dto.lead,
            imageUrl: dto.imageUrl.flatMap { URL(string: $0) }
        )
    }
}
