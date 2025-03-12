//
//  HerosCollectionViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit

enum HerosSection {
    case heros
}

final class HerosCollectionViewController: UICollectionViewController {
    // MARK: DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<HerosSection, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HerosSection, Hero>
    private var dataSource: DataSource?
    private let heros: [Hero] = []
    
    // MARK: Lifecycle
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.scrollDirection = .vertical
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    // MARK: CollectionView Configuration
    private func configureCollectionView() {
        let herosNib = UINib(nibName: HeroCollectionViewCell.identifier, bundle: nil)
        let registration = UICollectionView.CellRegistration<HeroCollectionViewCell, Hero>(cellNib: herosNib) { cell, indexPath, hero in
            cell.configure(with: hero)
        }
        
        dataSource = DataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, hero in
            collectionView.dequeueConfiguredReusableCell(
                using: registration,
                for: indexPath,
                item: hero)
        })
        
        collectionView.dataSource = dataSource
        applySnapshot()
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.heros])
        snapshot.appendItems(heros)
        dataSource?.apply(snapshot)
    }
}

// MARK: CollectionView Delegate
extension HerosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberCollumn: CGFloat = 2
        let itemWidth = (collectionView.frame.size.width - 32) / numberCollumn
        return CGSize(width: itemWidth, height: 200)
    }
}
