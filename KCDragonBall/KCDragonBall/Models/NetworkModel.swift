//
//  NetworkModel.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 10/03/25.
//
import Foundation

protocol NetworkModelProtocol {
    func jwt(user: String, password: String, completion: @escaping (Result<String, APIClientError>) -> ())
    func getHeros(completion: @escaping (Result<[Hero], APIClientError>) -> ())
    func getTransformations(for hero: Hero, completion: @escaping (Result<[Transformation], APIClientError>) -> ())
    func createURL(path: String) -> URL?
    var heroJSONObject: [String:Any] { get set }
    var storedJWT: String { get set }
}

final class NetworkModel: NetworkModelProtocol {
    static let shared = NetworkModel(apiClient: APIClient.shared)
    private let apiClient: APIClientProtocol
    // Base url components to use them for both jwt and request
    private var baseComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "dragonball.keepcoding.education"
        return urlComponents
    }
    internal var heroJSONObject: [String:Any]
    internal var storedJWT = ""
    
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        heroJSONObject = ["name":""]
    }
    
    func jwt(user: String, password: String, completion: @escaping (Result<String, APIClientError>) -> ()) {
        do {
            try RegexLint.validate(data: user, matchWith: .email)
            try RegexLint.validate(data: password, matchWith: .password)
            
            guard let url = createURL(path: "/api/auth/login") else {
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
            let authorizationHeader = "Basic \(encodedCredentials)"
            urlRequest.setValue(authorizationHeader, forHTTPHeaderField: "Authorization")
            
            // TODO: Replace for Keychain
            apiClient.jwt(request: urlRequest) { [weak self] result in
                switch result {
                case .success(let jwt):
                    self?.storedJWT = jwt
                case .failure:
                    break
                }
                completion(result)
            }
        } catch let apiClientError as APIClientError {
            completion(.failure(apiClientError))
        } catch {
            completion(.failure(APIClientError.unknown))
        }
    }
    
    func getHeros(completion: @escaping (Result<[Hero], APIClientError>) -> ()) {
        guard let url = createURL(path: "/api/heros/all") else {
            completion(.failure(.malformedURL))
            return
        }
        
        // TODO: Validate if JTW is stored
        // Research to decide between Singleton, UserDefaults and Keychain
        
        // JSONSerialization is an old class to convert Swift objects to JSON data
        // Ej. using a dictionary: try? JSONSerialization.data(withJSONObject: ["name": ""])
        // JSONEncoder requieres a defined struct that represents the JSON and conforms the Encodable protocol
        guard JSONSerialization.isValidJSONObject(heroJSONObject),
              let encodedHero = try? JSONSerialization.data(withJSONObject: heroJSONObject)
        else {
            completion(.failure(.encodingFailed))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        // The type of data we sent to the server in the httpBody
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // Authorize API requests using a token
        urlRequest.setValue("Bearer \(storedJWT)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = encodedHero
        
        apiClient.request(request: urlRequest, using: [Hero].self, completion: completion)
    }
    
    func getTransformations(for hero: Hero, completion: @escaping (Result<[Transformation], APIClientError>) -> ()) {
        var urlComponents = baseComponents
        urlComponents.path = "/api/heros/tranformations"
        
        guard let url = urlComponents.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        guard let encodedTransformation = try? JSONEncoder().encode(TransformationAPIModel(id: hero.id)) else {
            completion(.failure(.encodingFailed))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        // Authorize API requests using a token
        urlRequest.setValue("Bearer \(storedJWT)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = encodedTransformation
        
        apiClient.request(request: urlRequest, using: [Transformation].self, completion: completion)
    }
    
    func createURL(path: String) -> URL? {
        var urlComponents = baseComponents
        urlComponents.path = path
        return urlComponents.url
    }
}
