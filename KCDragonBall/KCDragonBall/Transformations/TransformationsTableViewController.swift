//
//  TransformationsTableViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit
import OSLog

enum TransformationsSection {
    case transformations
}

final class TransformationsTableViewController: UITableViewController {
    // MARK: DataSource
    typealias DataSource = UITableViewDiffableDataSource<TransformationsSection, Transformation>
    typealias Snapshot = NSDiffableDataSourceSnapshot<TransformationsSection, Transformation>
    private var dataSource: DataSource?
    private let networkModel: NetworkModelProtocol
    private let transformations: [Transformation]
    
    // MARK: Lifecycle
    init(networkModel: NetworkModelProtocol, transformations: [Transformation]) {
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
        configureTableView()
    }
    
    // MARK: TableView Configuration
    private func configureTableView() {
        let transformationsNib = UINib(
            nibName: TransformationTableViewCell.identifier,
            bundle: nil
        )
        
        tableView.register(transformationsNib, forCellReuseIdentifier: TransformationTableViewCell.identifier)
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, transformation in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: TransformationTableViewCell.identifier,
                for: indexPath
            ) as? TransformationTableViewCell else {
                Logger.debug.error("Unable to dequeue a cell of type \(TransformationTableViewCell.identifier)")
                return UITableViewCell()
            }
            cell.configure(with: transformation)
            cell.transformationTableViewCellDelegate = self
            return cell
        })
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        var snapshot = Snapshot()
        snapshot.appendSections([.transformations])
        snapshot.appendItems(transformations)
        dataSource?.apply(snapshot)
    }
}

// MARK: TableView Delegate
extension TransformationsTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
}

// MARK: TableViewCell Delegate
extension TransformationsTableViewController: TransformationTableViewCellProtocol {
    
    func readButtonTapped(transformation: Transformation) {
        let transformationDetailViewController = TransformationDetailViewController(
            transformation: transformation
        )
        present(transformationDetailViewController, animated: true)
    }
}
