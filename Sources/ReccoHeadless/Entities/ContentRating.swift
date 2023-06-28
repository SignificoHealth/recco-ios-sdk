import Foundation

public enum ContentRating: String, Codable, CaseIterable {
    case like = "like"
    case dislike = "dislike"
    case notRated = "not_rated"
}
