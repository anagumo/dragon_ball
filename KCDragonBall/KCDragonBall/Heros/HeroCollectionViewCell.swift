//
//  HeroCollectionViewCell.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: HeroCollectionViewCell.self)
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var favoriteImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    func configure(with hero: Hero) {
        favoriteImageView.image = hero.getFavoriteImage()
        favoriteImageView.tintColor = .dbOrange
        photoImageView.layer.backgroundColor = UIColor.systemGray6.cgColor
        photoImageView.setImage(stringURL: hero.photo)
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.layer.cornerRadius = 8
        nameLabel.text = hero.name
    }
}
