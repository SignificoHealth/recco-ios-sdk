//
//  File.swift
//  
//
//  Created by Adrián R on 30/5/23.
//

import Foundation

class BearerRequestBuilderFactory: RequestBuilderFactory {
    func getNonDecodableBuilder<T>() -> RequestBuilder<T>.Type {
        BearerRequestBuilder<T>.self
    }

    func getBuilder<T: Decodable>() -> RequestBuilder<T>.Type {
        BearerDecodableRequestBuilder<T>.self
    }
}

class BearerRequestBuilder<T>: URLSessionRequestBuilder<T> {
    @discardableResult
    override func execute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {

        guard self.requiresAuthentication,
              !self.URLString.contains("login"),
              !self.URLString.contains("logout") else {
            return super.execute(apiResponseQueue, completion)
        }

        // Before making the request, we can validate if we have a bearer token to be able to make a request
        BearerTokenHandler.refreshTokenIfDoesntExist { token, error in
            guard error == nil, let token = token else {
                completion(.failure(.error(999999, nil, nil, error ?? NSError() as Error))); return
            }
            
            self.addHeaders(["Authorization": "Bearer \(token)"])
            
            // Here we make the request
            super.execute(apiResponseQueue) { result in
                switch result {
                case .success:
                    // If we got a successful response, we send the response to the completion block
                    completion(result)
                    
                case let .failure(error):
                    // If we got a failure response, we will analyse the error to see what we should do with it
                    if case let ErrorResponse.error(_, data, response, error) = error {
                        
                        // If the error is an ErrorResponse.error() we will analyse it to see if it's a 401, and if it's a 401, we will refresh the token and retry the request
                        BearerTokenHandler.refreshTokenIfUnauthorizedRequestResponse(
                            data: data,
                            response: response,
                            error: error
                        ) { (wasTokenRefreshed, newToken) in
                            if wasTokenRefreshed, let newToken = newToken {
                                // If the token was refreshed, it's because it was a 401 error, so we refreshed the token, and we are going to retry the request by calling self.execute()
                                self.addHeaders(["Authorization": "Bearer \(newToken)"])
                                self.execute(apiResponseQueue, completion)
                            } else {
                                // If the token was not refreshed, it's because it was not a 401 error, so we send the response to the completion block
                                completion(result)
                            }
                        }
                    } else {
                        // If it's an unknown error, we send the response to the completion block
                        completion(result)
                    }
                    
                }
            }
        }
        
        return requestTask
    }
}

class BearerDecodableRequestBuilder<T: Decodable>: URLSessionDecodableRequestBuilder<T> {

    @discardableResult
    override func execute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue, _ completion: @escaping (Result<Response<T>, ErrorResponse>) -> Void) -> RequestTask {
        
        guard self.requiresAuthentication && !self.URLString.contains("login"), !self.URLString.contains("logout") else {
            return super.execute(apiResponseQueue, completion)
        }

        // Before making the request, we can validate if we have a bearer token to be able to make a request
        BearerTokenHandler.refreshTokenIfDoesntExist { token, error  in
            guard error == nil, let token = token else {
                completion(.failure(.error(999999, nil, nil, error ?? NSError() as Error))); return
            }
            
            self.addHeaders(["Authorization": "Bearer \(token)"])
            
            // Here we make the request
            super.execute(apiResponseQueue) { result in
                
                switch result {
                case .success:
                    // If we got a successful response, we send the response to the completion block
                    completion(result)
                    
                case let .failure(error):
                    
                    // If we got a failure response, we will analyse the error to see what we should do with it
                    if case let ErrorResponse.error(_, data, response, error) = error {
                        
                        // If the error is an ErrorResponse.error() we will analyse it to see if it's a 401, and if it's a 401, we will refresh the token and retry the request
                        BearerTokenHandler.refreshTokenIfUnauthorizedRequestResponse(
                            data: data,
                            response: response,
                            error: error
                        ) { (wasTokenRefreshed, newToken) in
                            
                            if wasTokenRefreshed, let newToken = newToken {
                                
                                // If the token was refreshed, it's because it was a 401 error, so we refreshed the token, and we are going to retry the request by calling self.execute()
                                self.addHeaders(["Authorization": "Bearer \(newToken)"])
                                self.execute(apiResponseQueue, completion)
                            } else {
                                // If the token was not refreshed, it's because it was not a 401 error, so we send the response to the completion block
                                completion(result)
                            }
                        }
                    } else {
                        // If it's an unknown error, we send the response to the completion block
                        completion(result)
                    }
                    
                }
            }
        }
        
        return requestTask
    }
}

public class BearerTokenHandler {
    static var bearerToken: String? = nil
    static var clientSecret: String!
    static var clientId: String?
    static var keychain: KeychainProxy!

    static func refreshTokenIfDoesntExist(completionHandler: @escaping (String?, Error?) -> Void) {
        if let bearerToken = bearerToken {
            completionHandler(bearerToken, nil)
        } else {
            startRefreshingToken { token, error in
                completionHandler(token, error)
            }
        }
    }
    
    static func refreshTokenIfUnauthorizedRequestResponse(data: Data?, response: URLResponse?, error: Error?, completionHandler: @escaping (Bool, String?) -> Void) {
        if let response = response as? HTTPURLResponse, response.statusCode == 401 {
            startRefreshingToken { token, error in
                if error != nil {
                    completionHandler(false, nil)
                } else {
                    completionHandler(true, token)
                }
            }
        } else {
            completionHandler(false, nil)
        }
    }
    
    private static func startRefreshingToken(completionHandler: @escaping (String?, Error?) -> Void) {
        
        struct NoClientIdError: Error {}
        guard let clientId = clientId else {
            completionHandler(nil, NoClientIdError()); return
        }
        
        Task {
            do {
                let token = try await AuthenticationAPI.login(authorization: clientSecret, clientUserId: clientId)
                bearerToken = token.accessToken
                try keychain.save(key: .currentPat, token)
                try keychain.save(key: .clientUserId, clientId)
                completionHandler(token.accessToken, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
    }
}
