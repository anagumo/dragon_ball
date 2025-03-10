//
//  NetworkModel.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 10/03/25.
//
import Foundation

struct NetworkModel {
    static let shared = NetworkModel(apiClient: APIClient.shared)
    private let apiClient: APIClientProtocol
    // Base url components to use them for both jwt and request
    private var baseComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "dragonball.keepcoding.education"
        return urlComponents
    }
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }
    
    func jwt(user: String, password: String, completion: @escaping (Result<String, APIClientError>) -> ()) {
        var urlComponents = baseComponents
        urlComponents.path = "/api/auth/login"
        
        guard let url = urlComponents.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        let loginCredentials = String(format: "%@:%@", user, password)
        // 1. Converts the user and password to binary data
        // 2. Basic Authentication requires Base64 encoding for credentials
        guard let encodedCredentials = loginCredentials
            .data(using: .utf8)?
            .base64EncodedString() else {
            completion(.failure(.encodingFailed))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        // Create and set authentication header
        let authenticationHeader = "Basic \(encodedCredentials)"
        urlRequest.setValue(authenticationHeader, forHTTPHeaderField: "Authorization")
        
        apiClient.jwt(request: urlRequest, completion: completion)
    }
}
