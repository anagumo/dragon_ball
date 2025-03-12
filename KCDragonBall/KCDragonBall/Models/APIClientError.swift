//
//  LoginError.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 11/03/25.
//

import Foundation

/// Representation of an app error
///
/// # Implementation
/// Use a custom init to create an instance from an (`Error`) or a (`RegexPattern`)
///
/// Usage:
///```swift
///let appError = AppError(from: error)
///
///let appError1 = AppError(from: .username)
///print(appError.errorDescription)
///```
///
///Output:
///```
///"Error: el nombre de usuario no debe estar vacío"
///```
/// Representation of an API client error
enum APIClientError: Error, Equatable {
    case malformedURL
    case noData
    case statusCode(statusCode: Int?)
    case decodingFailed
    case encodingFailed
    case emailFormat
    case passwordFormat
    case unknown
    
    // This initializer was created to throw a custom error in the RegexLint
    init(from regex: RegexPattern) {
        switch regex {
        case .email:
            self = .emailFormat
        case .password:
            self = .passwordFormat
        }
    }
    
    var message: String {
        switch self {
        case .malformedURL:
            "Malformed URL"
        case .noData:
            "No Data"
        case .statusCode(let statusCode):
            "Error Code: \(String(describing: statusCode))"
        case .decodingFailed:
            "Decoding Failed"
        case .encodingFailed:
            "Encoding Failed"
        case .emailFormat:
            "Invalid email format"
        case .passwordFormat:
            "The password must have at least 8 characters"
        case .unknown:
            "Unknown error"
        }
    }
}
