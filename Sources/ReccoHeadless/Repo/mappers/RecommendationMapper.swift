import Foundation

extension AppUserRecommendation {
    init(dto: AppUserRecommendationDTO) throws {
        self.init(
            id: .init(dto: dto.id),
            type: .init(dto: dto.type),
            rating: .init(dto: dto.rating),
            status: .init(dto: dto.status),
            headline: dto.headline,
            imageUrl: dto.dynamicImageResizingUrl.flatMap { URL(string: $0) },
            imageAlt: dto.imageAlt
        )
    }
}
