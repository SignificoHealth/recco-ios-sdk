import Foundation

public protocol ContentRepository {
    func setRating(_ updateRating: UpdateRating) async throws
    func setBookmark(_ updateBookmark: UpdateBookmark) async throws
}

final class LiveContentRepository: ContentRepository {
    func setRating(_ updateRating: UpdateRating) async throws {
        try await RecommendationAPI.setRating(
            updateRatingDTO: .init(
                contentId: .init(entity: updateRating.contentId),
                contentType: updateRating.contentType == .articles ? .articles : .articles,
                rating: updateRating.rating == .like ? .like : updateRating.rating == .dislike ? .dislike : .notRated
            )
        )
    }

    func setBookmark(_ updateBookmark: UpdateBookmark) async throws {
        try await RecommendationAPI.setBookmark(
            updateBookmarkDTO: .init(
                contentId: .init(entity: updateBookmark.contentId),
                contentType: updateBookmark.contentType == .articles ? .articles : .articles,
                bookmarked: updateBookmark.bookmarked
            )
        )
    }
}
