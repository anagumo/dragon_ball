//
//  TransformationDetailViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 13/03/25.
//

import UIKit

final class TransformationDetailViewController: UIViewController {
    // MARK: UI Components
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    // MARK: DataSource
    private var transformation: Transformation
    
    // MARK: Lifecycle
    init(transformation: Transformation) {
        self.transformation = transformation
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = transformation.name
        descriptionLabel.text = transformation.description
    }
}
