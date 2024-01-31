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
            durationSeconds: dto.duration
        )
    }
}

extension ContentCategory {
    init(dto: AppUserVideoDTO.CategoryDTO) {
        switch dto {
        case .exercise:
            self = .exercise
        case .meditation:
            self = .meditation
        }
    }

    init(dto: AppUserAudioDTO.CategoryDTO) {
        switch dto {
        case .exercise:
            self = .exercise
        case .meditation:
            self = .meditation
        case .relaxation:
            self = .relaxation
        }
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
            category: .init(dto: dto.category),
            disclaimer: dto.disclaimer,
            warning: dto.warning,
            dynamicImageResizingUrl: dto.dynamicImageResizingUrl.flatMap { URL(string: $0) },
            imageAlt: dto.imageAlt,
            mediaUrl: videoUrl,
            duration: dto.duration,
            textIsTranscription: false
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
            category: .init(dto: dto.category),
            dynamicImageResizingUrl: dto.dynamicImageResizingUrl.flatMap { URL(string: $0) },
            imageAlt: dto.imageAlt,
            mediaUrl: audioUrl,
            duration: dto.duration,
            textIsTranscription: dto.transcription
        )
    }
}
