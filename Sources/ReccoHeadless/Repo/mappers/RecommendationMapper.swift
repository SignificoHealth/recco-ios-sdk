import Foundation

extension AppUserRecommendation {
    init(dto: AppUserRecommendationDTO) throws {
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
