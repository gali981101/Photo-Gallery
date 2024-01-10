//
//  ViewController.swift
//  Photosgallery
//
//  Created by Terry Jason on 2024/1/5.
//

import UIKit

class PhotosViewController: UIViewController {
    
    private var favoriteImages = (1...15).map { "favorite-\($0)" }
    private var photoImages = (1...25).map { "photo-\($0)" }
    private var recentImages = (1...35).map { "recent-\($0)" }
    
    private lazy var dataSource = configureDataSource()
    
    // MARK: - @IBOulet
    
    @IBOutlet var collectionView: UICollectionView!
    
}

// MARK: - Section

extension PhotosViewController {
    
    enum Section: Int {
        case favorite
        case photo
        case recent
        
        var columnCount: Int {
            switch self {
            case .favorite:
                return 1
            case .photo:
                return 2
            case .recent:
                return 3
            }
        }
        
        var groupHight: CGFloat {
            switch self {
            case .favorite:
                return 400.0
            case .photo:
                return 300.0
            case .recent:
                return 200.0
            }
        }
        
        var name: String {
            switch self {
            case .favorite:
                return "Favorite"
            case .photo:
                return "Photos"
            case .recent:
                return "Recent"
            }
        }
    }
    
}

// MARK: - Life Cycle

extension PhotosViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        collectionView.collectionViewLayout = createMultiGridLayout()
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: "header", withReuseIdentifier: "header")
        
        configureHeader()
        
        updateSnapshot()
    }
    
}

// MARK: - Header Set Up

extension PhotosViewController {
    
    private func configureHeader() {
        dataSource.supplementaryViewProvider = supplementary(collectionView:kind:indexPath:)
    }
    
    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        if kind == UICollectionView.elementKindSectionFooter {
            return nil
        }
        
        let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "header", for: indexPath) as! SectionHeaderView
        headerView.titleLabel.text = section.name
        
        return headerView
    }
    
}

// MARK: - Compositional Layouts

extension PhotosViewController {
        
    private func createMultiGridLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            var column: Int = 1
            
            guard let dataSection = Section(rawValue: sectionIndex) else { fatalError() }
            column = dataSection.columnCount
            
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/CGFloat(column)), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let groupHight = dataSection.groupHight
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(groupHight))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
   
            
            let edge: CGFloat = sectionIndex == 0 ? 10 : 0
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: edge, bottom: 0, trailing: edge)
            
            let section = NSCollectionLayoutSection(group: group)
            
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
            let headerElement = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
            
            section.boundarySupplementaryItems = [headerElement]
            
            return section
        }
        
        return layout
        
    }
    
}

// MARK: - Diffable Data Source

extension PhotosViewController {
    
    private func configureDataSource() -> UICollectionViewDiffableDataSource<Section, String> {
        
        let dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView) { collectionView, indexPath, imageName in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoCollectionViewCell
            cell.imageView.image = UIImage(named: imageName)
            
            return cell
        }
        
        return dataSource
        
    }
    
    private func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.favorite, .photo, .recent])
        
        snapshot.appendItems(favoriteImages, toSection: .favorite)
        snapshot.appendItems(photoImages, toSection: .photo)
        snapshot.appendItems(recentImages, toSection: .recent)
        
        dataSource.apply(snapshot, animatingDifferences: animatingChange)
    }
    
}

// MARK: - UICollectionViewDelegate

extension PhotosViewController: UICollectionViewDelegate {
}










