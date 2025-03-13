//
//  HerosCollectionViewController.swift
//  KCDragonBall
//
//  Created by Ariana Rodríguez on 12/03/25.
//

import UIKit
import OSLog

enum HerosSection {
    case heros
}

final class HerosCollectionViewController: UICollectionViewController {
    // MARK: DataSource
    typealias DataSource = UICollectionViewDiffableDataSource<HerosSection, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<HerosSection, Hero>
    private var dataSource: DataSource?
    private let heros: [Hero] = []
    private let networkModel: NetworkModelProtocol
    
    // MARK: Lifecycle
    init(networwModel: NetworkModelProtocol) {
        self.networkModel = networwModel
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
        title = "Heros"
        configureCollectionView()
        getHeros()
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
        collectionView.delegate = self
    }
    
    private func applySnapshot(heros: [Hero]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.heros])
        snapshot.appendItems(heros)
        dataSource?.apply(snapshot)
    }
    
    private func getHeros() {
        networkModel.getHeroes { result in
            switch result {
            case .success(let heros):
                DispatchQueue.main.async {
                    self.applySnapshot(heros: heros)
                }
            case .failure(let error):
                Logger.debug.error("\(error.message)")
            }
        }
    }
}

// MARK: CollectionView Delegate
extension HerosCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberCollumn: CGFloat = 2
        let itemWidth = (collectionView.frame.size.width - 32) / numberCollumn
        return CGSize(width: itemWidth, height: 220)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let hero = dataSource?.itemIdentifier(for: indexPath) as? Hero else {
            Logger.debug.error("No Hero item found in DataSource")
            return
        }
        
        let heroDetailViewController = HeroDetailViewController(hero: hero)
        show(heroDetailViewController, sender: self)
    }
}
