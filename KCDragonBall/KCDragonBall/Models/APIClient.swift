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
    case statusCode(statusCode: Int?)
    case decodingFailed
    case encodingFailed
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
    static let shared = APIClient(urlSession: .shared)
    let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func jwt(request: URLRequest, completion: @escaping (Result<String, APIClientError>) -> ()) {
        let dataTask = urlSession.dataTask(with: request) {data, response, error in
            // Is good practice validate first if there is an error
            guard error == nil else {
                // To be able to know the status code is necessary cast to NSError
                guard let error = error as? NSError else {
                    completion(.failure(.unknown))
                    return
                }
                completion(.failure(.statusCode(statusCode: error.code)))
                return
            }
            
            // If the request does not fail handle success response
            guard let data else {
                completion(.failure(.noData))
                return
            }
            
            let response = response as? HTTPURLResponse
            guard let response, response.statusCode == 200 else {
                completion(.failure(.statusCode(statusCode: response?.statusCode)))
                return
            }
            
            guard let jwt = String(data: data, encoding: .utf8) else {
                completion(.failure(.decodingFailed))
                return
            }
            
            completion(.success(jwt))
        }
        
        dataTask.resume()
    }
    
    func request<T>(request: URLRequest, using: T.Type, completion: @escaping (Result<T, APIClientError>) -> ()) where T : Decodable {
        // TODO: Add definition
    }
}
