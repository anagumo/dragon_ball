//
//  Hero.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 10/03/25.
//
import Foundation
import UIKit

/// Represents a protocol to share data between domain and API model
protocol Nameable {
    var name: String { get }
}
/// Represents a domain model
struct Hero: Nameable, Decodable, Hashable {
    let id: String
    let favorite: Bool
    let name: String
    let description: String
    let photo: String
}

/// Represents an API Model
struct HeroAPIModel: Nameable, Encodable {
    let name: String
}

extension Hero {
    
    func getFavoriteImage() -> UIImage? {
        UIImage(systemName: favorite ? "heart.fill" : "heart")
    }
}
