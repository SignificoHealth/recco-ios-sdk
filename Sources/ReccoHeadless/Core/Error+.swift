import Foundation

public extension Error {
    var originalError: Error {
        if let apiError = self as? ErrorResponse, case let .error(_, _, _, errorResponse) = apiError {
            return errorResponse
        } else {
            return self
        }
    }
}
