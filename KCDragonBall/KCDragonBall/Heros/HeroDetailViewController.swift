//
//  HeroDetailViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit

final class HeroDetailViewController: UIViewController {
    // MARK: UI Components
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var transformationsButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: DataSource
    private let hero: Hero
    
    // MARK: Lifecycle
    init(hero: Hero) {
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.setImage(stringURL: hero.photo)
        photoImageView.contentMode = .scaleAspectFill
        nameLabel.text = hero.name
        descriptionLabel.text = hero.description
        customizeButtons()
    }
}

extension HeroDetailViewController {
    // MARK: UI Components customization
    private func customizeButtons() {
        var transformationConfiguration = UIButton.Configuration.filled()
        transformationConfiguration.cornerStyle = .capsule
        transformationConfiguration.baseBackgroundColor = .dbOrange
        transformationConfiguration.image = UIImage(systemName: "bolt.circle.fill")
        transformationConfiguration.imagePlacement = .leading
        transformationConfiguration.imagePadding = 4
        transformationConfiguration.baseForegroundColor = .dbBlack
        transformationConfiguration.attributedTitle = AttributedString(
            "Transformations",
            attributes: AttributeContainer([
                .font: UIFont.systemFont(ofSize: 15, weight: .semibold),
                .foregroundColor: UIColor.dbBlack
            ]))
        transformationsButton.configuration = transformationConfiguration
    }
}
