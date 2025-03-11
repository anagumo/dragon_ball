//
//  Transformation.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 10/03/25.
//
import Foundation

/// Represents a protocol to share data between domain and API model
protocol TransformationIdentifiable {
    var id: String { get }
}

/// Represents a domain model
struct Transformation: TransformationIdentifiable, Codable {
    let name: String
    let description: String
    let photo: String
    let id: String
}

/// Represents an API model
struct TransformationAPIModel: TransformationIdentifiable, Encodable {
    let id: String
}
