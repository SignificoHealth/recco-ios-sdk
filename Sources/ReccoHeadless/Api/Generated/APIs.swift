// APIs.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
internal class OpenAPIClientAPI {
    internal static var basePath = "https://recco-api.significo.dev"
    internal static var customHeaders: [String: String] = [:]
    internal static var credential: URLCredential?
    internal static var requestBuilderFactory: RequestBuilderFactory = URLSessionRequestBuilderFactory()
    internal static var apiResponseQueue: DispatchQueue = .main
}

internal class RequestBuilder<T> {
    var credential: URLCredential?
    var headers: [String: String]
    internal let parameters: [String: Any]?
    internal let method: String
    internal let URLString: String
    internal let requestTask: RequestTask = RequestTask()
    internal let requiresAuthentication: Bool

    /// Optional block to obtain a reference to the request's progress instance when available.
    internal var onProgressReady: ((Progress) -> Void)?

    required internal init(method: String, URLString: String, parameters: [String: Any]?, headers: [String: String] = [:], requiresAuthentication: Bool) {
        self.method = method
        self.URLString = URLString
        self.parameters = parameters
        self.headers = headers
        self.requiresAuthentication = requiresAuthentication

        addHeaders(OpenAPIClientAPI.customHeaders)
    }

    internal func addHeaders(_ aHeaders: [String: String]) {
        for (header, value) in aHeaders {
            headers[header] = value
        }
    }

    @discardableResult
    internal func execute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, _ completion: @escaping (_ result: Swift.Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        return requestTask
    }

    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    @discardableResult
    internal func execute() async throws -> Response<T> {
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            return try await withCheckedThrowingContinuation { continuation in
                guard !Task.isCancelled else {
                  continuation.resume(throwing: CancellationError())
                  return
                }

                self.execute { result in
                    switch result {
                    case let .success(response):
                        continuation.resume(returning: response)
                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } onCancel: {
            self.requestTask.cancel()
        }
    }
    
    internal func addHeader(name: String, value: String) -> Self {
        if !value.isEmpty {
            headers[name] = value
        }
        return self
    }

    internal func addCredential() -> Self {
        credential = OpenAPIClientAPI.credential
        return self
    }
}

internal protocol RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type
    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type
}
