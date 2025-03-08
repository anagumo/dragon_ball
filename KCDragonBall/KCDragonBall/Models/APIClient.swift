//
//  APIClient.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 07/03/25.
//

import Foundation

/// Representation of an API client error
enum APIClientError: Error {
    case malformedURL
    case noData
    case statusCode(statusCode: Int)
    case decodingFailed
    case unknown
}

protocol APIClientProtocol {
    /// Function to get the JWT from the server
    /// - Parameters:
    ///   - request: An object of type `(URLRequest)` that represents a request to the server and contains an URL, headers and methods such as GET
    ///   - completion: a completion handler of type `(Result<String, APIClientError>)` that represents the data result and returns either a jwt or an error
    func jwt(request: URLRequest, completion: @escaping (Result<String, APIClientError>) -> ())
    /// Generic function to get a hero or transformation from the server but is available for any type that conforms the Codable protocol
    /// - Parameters:
    ///   - request: An object of type `(URLRequest)` that represents a request to the server and contains an URL, headers and methods such as GET
    ///   - using: A generic type of type `(Any)` that represents a Hero or a Tranformation
    ///   - completion: a completion handler of type `(Result<T, APIClientError>) -> ())` that represents the data result and returns either an any type or an error
    func request<T: Decodable>(request: URLRequest, using: T.Type, completion: @escaping (Result<T, APIClientError>) -> ())
}

struct APIClient: APIClientProtocol {
    let urlSession: URLSession
    
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    func jwt(request: URLRequest, completion: @escaping (Result<String, APIClientError>) -> ()) {
        // TODO: Add definition
    }
    
    func request<T>(request: URLRequest, using: T.Type, completion: @escaping (Result<T, APIClientError>) -> ()) where T : Decodable {
        // TODO: Add definition
    }
}
