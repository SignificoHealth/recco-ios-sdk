//
//  File.swift
//  
//
//  Created by Adrián R on 8/6/23.
//

import Foundation
import SFApi
import SFEntities

public protocol ContentRepository {
    func setStatus(_ updateStatus: UpdateStatus) async throws
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
    
    func setStatus(_ updateStatus: UpdateStatus) async throws {
        try await RecommendationAPI.setStatus(
            updateStatusDTO: .init(
                contentId: .init(entity: updateStatus.contentId),
                contentType: updateStatus.contentType == .articles ? .articles : .articles,
                status: updateStatus.status == .noInteraction ? .noInteraction : .viewed
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
