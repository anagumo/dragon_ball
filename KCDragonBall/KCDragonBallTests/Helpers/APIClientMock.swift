//
//  APIClientMock.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 14/03/25.
//

import Foundation
@testable import KCDragonBall

/// Implement a mock where we control the dependency with a protocol to replace the behaivor of the API Client
final class APIClientMock: APIClientProtocol {
    var didCallJWT = false
    var receiveJWTRequest: URLRequest?
    var receiveJWTResult: Result<String, APIClientError>?
    func jwt(request: URLRequest, completion: @escaping (Result<String, APIClientError>) -> ()) {
        didCallJWT = true
        receiveJWTRequest = request
        
        if let result = receiveJWTResult {
            completion(result)
        }
    }
    
    var didCallRequest = false
    var receiveRequest: URLRequest?
    var receiveHeroResult: Result<[Hero], APIClientError>?
    var receiveTransformationResult: Result<[Transformation], APIClientError>?
    func request<T>(request: URLRequest, using: T.Type, completion: @escaping (Result<T, APIClientError>) -> ()) where T : Decodable {
        didCallRequest = true
        receiveRequest = request
        
        if let heroResult = receiveHeroResult as? Result<T, APIClientError> {
            completion(heroResult)
        }
        
        if let transformationResult = receiveTransformationResult as? Result<T, APIClientError> {
            completion(transformationResult)
        }
    }
}
