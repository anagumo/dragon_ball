//
//  HeroDetailViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit
import OSLog

final class HeroDetailViewController: UIViewController {
    // MARK: UI Components
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var transformationsButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: DataSource
    private var networkModel: NetworkModelProtocol
    private let hero: Hero
    private var transformations: [Transformation] = []
    
    // MARK: Lifecycle
    init(networkModel: NetworkModelProtocol, hero: Hero) {
        self.networkModel = networkModel
        self.hero = hero
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeButtons()
        configureHero()
        getTransformations()
    }
    
    @objc func favoriteBarButtonItemTapped(_ sender: UIBarButtonItem) {
        // TODO: Call /api/data/herolike
        Logger.debug.log("Favorite Hero tapped")
        let uiAlertController = UIAlertController(
            title: "Unavailable Feature",
            message: "Call to /api/data/herolike in Postman to test the favorite state",
            preferredStyle: .alert)
        
        uiAlertController.addAction(
            UIAlertAction(
                title: "OK",
                style: .default
            )
        )
        
        present(uiAlertController, animated: true)
    }
    
    private func configureHero() {
        photoImageView.setImage(stringURL: hero.photo)
        photoImageView.contentMode = .scaleAspectFill
        nameLabel.text = hero.name
        descriptionLabel.text = hero.description
    }
    
    private func getTransformations() {
        networkModel.getTransformations(for: hero) { [weak self] result in
            switch result {
            case let .success(transformations):
                guard !transformations.isEmpty else {
                    let heroName = self?.hero.name ?? ""
                    Logger.debug.error("Transformations for \(heroName) not found")
                    return
                }
                self?.transformations = transformations
                DispatchQueue.main.async {
                    self?.transformationsButton.isHidden = false
                }
            case let .failure(error):
                Logger.debug.error("\(error.message)")
            }
        }
    }
    
    // MARK: Oulet Actions
    @IBAction func transformationsButtonTapped(_ sender: Any) {
        let transformationsTableViewController = TransformationsTableViewController(
            networkModel: networkModel,
            transformations: transformations
        )
        show(transformationsTableViewController, sender: self)
    }
}

extension HeroDetailViewController {
    // MARK: UI Components customization
    private func customizeButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: hero.getFavoriteImage(),
            style: .plain,
            target: self,
            action: #selector(favoriteBarButtonItemTapped)
        )
        
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
