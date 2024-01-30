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
            imageAlt: dto.imageAlt,
            durationSeconds: dto.length
        )
    }
}

extension AppUserMedia {
    init(dto: AppUserVideoDTO) throws {
        guard let videoUrl = URL(string: dto.videoUrl) else {
            struct InvalidVideoUrl: Error {}
            throw InvalidVideoUrl()
        }

        self.init(
            type: .video,
            id: .init(dto: dto.id),
            rating: .init(dto: dto.rating),
            status: .init(dto: dto.status),
            bookmarked: dto.bookmarked,
            headline: dto.headline,
            description: dto.description,
            category: dto.category,
            disclaimer: dto.disclaimer,
            warning: dto.warning,
            dynamicImageResizingUrl: dto.dynamicImageResizingUrl.flatMap { URL(string: $0) },
            imageAlt: dto.imageAlt,
            mediaUrl: videoUrl,
            length: dto.length
        )
    }

    init(dto: AppUserAudioDTO) throws {
        guard let audioUrl = URL(string: dto.audioUrl) else {
            struct InvalidAudioUrl: Error {}
            throw InvalidAudioUrl()
        }

        self.init(
            type: .audio,
            id: .init(dto: dto.id),
            rating: .init(dto: dto.rating),
            status: .init(dto: dto.status),
            bookmarked: dto.bookmarked,
            headline: dto.headline,
            description: dto.description,
            category: dto.category,
            dynamicImageResizingUrl: dto.dynamicImageResizingUrl.flatMap { URL(string: $0) },
            imageAlt: dto.imageAlt,
            mediaUrl: audioUrl,
            length: dto.length
        )
    }
}
