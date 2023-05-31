//
// AuthenticationAPI.swift
//
// Generated by openapi-generator
// https://openapi-generator.tech
//

import Foundation
#if canImport(AnyCodable)
import AnyCodable
#endif

open class AuthenticationAPI {

    /**
     Authenticate an app user supplying an app PAT and the associated user client id.         If the user client id does not exist in the app, a new user will be registered on the fly.         This endpoint should be used also after the PAT expires to retrieve a new one.         
     
     - parameter authorization: (header)  
     - parameter clientUserId: (header)  
     - returns: PATDTO
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func login(authorization: String, clientUserId: String) async throws -> PATDTO {
        return try await loginWithRequestBuilder(authorization: authorization, clientUserId: clientUserId).execute().body
    }

    /**
     Authenticate an app user supplying an app PAT and the associated user client id.         If the user client id does not exist in the app, a new user will be registered on the fly.         This endpoint should be used also after the PAT expires to retrieve a new one.         
     - POST /api/v1/app_users/login
     - BASIC:
       - type: http
       - name: bearerAuth
     - parameter authorization: (header)  
     - parameter clientUserId: (header)  
     - returns: RequestBuilder<PATDTO> 
     */
    open class func loginWithRequestBuilder(authorization: String, clientUserId: String) -> RequestBuilder<PATDTO> {
        let localVariablePath = "/api/v1/app_users/login"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters: [String: Any]? = nil

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Authorization": authorization.encodeToJSON(),
            "Client-User-Id": clientUserId.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<PATDTO>.Type = OpenAPIClientAPI.requestBuilderFactory.getBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }

    /**
     Logout an app user supplying PAT's id and the associated user client id.
     
     - parameter authorization: (header)  
     - parameter clientUserId: (header)  
     - parameter pATReferenceDeleteDTO: (body)  
     - returns: Void
     */
    @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    open class func logout(authorization: String, clientUserId: String, pATReferenceDeleteDTO: PATReferenceDeleteDTO) async throws {
        return try await logoutWithRequestBuilder(authorization: authorization, clientUserId: clientUserId, pATReferenceDeleteDTO: pATReferenceDeleteDTO).execute().body
    }

    /**
     Logout an app user supplying PAT's id and the associated user client id.
     - POST /api/v1/app_users/logout
     - BASIC:
       - type: http
       - name: bearerAuth
     - parameter authorization: (header)  
     - parameter clientUserId: (header)  
     - parameter pATReferenceDeleteDTO: (body)  
     - returns: RequestBuilder<Void> 
     */
    open class func logoutWithRequestBuilder(authorization: String, clientUserId: String, pATReferenceDeleteDTO: PATReferenceDeleteDTO) -> RequestBuilder<Void> {
        let localVariablePath = "/api/v1/app_users/logout"
        let localVariableURLString = OpenAPIClientAPI.basePath + localVariablePath
        let localVariableParameters = JSONEncodingHelper.encodingParameters(forEncodableObject: pATReferenceDeleteDTO)

        let localVariableUrlComponents = URLComponents(string: localVariableURLString)

        let localVariableNillableHeaders: [String: Any?] = [
            "Authorization": authorization.encodeToJSON(),
            "Client-User-Id": clientUserId.encodeToJSON(),
        ]

        let localVariableHeaderParameters = APIHelper.rejectNilHeaders(localVariableNillableHeaders)

        let localVariableRequestBuilder: RequestBuilder<Void>.Type = OpenAPIClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return localVariableRequestBuilder.init(method: "POST", URLString: (localVariableUrlComponents?.string ?? localVariableURLString), parameters: localVariableParameters, headers: localVariableHeaderParameters, requiresAuthentication: true)
    }
}
