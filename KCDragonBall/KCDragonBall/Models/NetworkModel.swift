//
//  NetworkModel.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 10/03/25.
//
import Foundation

protocol NetworkModelProtocol {
    func jwt(user: String, password: String, completion: @escaping (Result<String, APIClientError>) -> ())
    func getHeroes(name: String, completion: @escaping (Result<[Hero], APIClientError>) -> ())
}

struct NetworkModel: NetworkModelProtocol {
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
    
    func getHeroes(name: String = "", completion: @escaping (Result<[Hero], APIClientError>) -> ()) {
        var urlComponents = baseComponents
        urlComponents.path = "/api/heros/all"
        
        guard let url = urlComponents.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        // TODO: Validate if JTW is stored
        
        // JSONSerialization is an old class to convert Swift objects to JSON data
        // Ej. using a dictionary: try? JSONSerialization.data(withJSONObject: ["name": ""])
        // JSONEncoder requieres a defined struct that represents the JSON and conforms the Encodable protocol
        guard let encodedHero = try? JSONEncoder().encode(HeroAPIModel(name: name)) else {
            completion(.failure(.encodingFailed))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer {jwt}", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = encodedHero
        
        apiClient.request(request: urlRequest, using: [Hero].self, completion: completion)
    }
}
