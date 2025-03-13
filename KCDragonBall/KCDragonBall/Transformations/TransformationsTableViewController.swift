//
//  TransformationsTableViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit

final class TransformationsTableViewController: UITableViewController {
    // MARK: DataSource
    private let networkModel: NetworkModel
    private let transformations: [Transformation]
    
    // MARK: Lifecycle
    init(networkModel: NetworkModel, transformations: [Transformation]) {
        self.networkModel = networkModel
        self.transformations = transformations
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transformations"
    }
}
