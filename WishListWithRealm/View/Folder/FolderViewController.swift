//
//  FolderViewController.swift
//  WishListWithRealm
//
//  Created by 박준우 on 3/5/25.
//

import UIKit

import SnapKit

final class FolderViewController: BaseViewController {
    
    private enum Section: CaseIterable {
        case First
    }
    
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: self.configureCollectionViewLayout())
    private var dataSource: UICollectionViewDiffableDataSource<Section, Folder>!
    
    private let folderRepo: FolderRepositoryInterface = FolderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureCollectionViewDataSource()
    
        self.collectionView.delegate = self
        self.updateCollectionView()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(self.collectionView)
    }
    
    override func configureLayout() {
        self.collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        self.navigationItem.title = "WishList Folder"
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(self.createFolder))
        self.navigationItem.setRightBarButton(rightItem, animated: true)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
        
        let listConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        
        let layout = UICollectionViewCompositionalLayout.list(using: listConfig)
        
        return layout
    }
    
    private func configureCollectionViewDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Folder> { cell, indexPath, itemIdentifier in
            var content = UIListContentConfiguration.valueCell()
            content.text = itemIdentifier.name
            content.secondaryText = "\(itemIdentifier.wishList.count)개"
            cell.contentConfiguration = content
        }
        
        self.dataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView) { collectionView, indexPath, itemIdentifier in
            let cell  = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
    }
    
    private func updateCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Folder>()
        
        let sections = Section.allCases
        
        snapshot.appendSections(sections)
        
        sections.forEach { section in
            snapshot.appendItems(Array(self.folderRepo.fetchFolder()), toSection: section)
        }
        
        self.dataSource.apply(snapshot)
    }
    
    @objc private func createFolder() {
        self.folderRepo.createFolder(name: "폴더\(self.folderRepo.fetchFolder().count)")
        self.updateCollectionView()
    }
}

extension FolderViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let data = self.folderRepo.fetchFolder()[indexPath.item]
        self.folderRepo.deleteFolder(folder: data)
    }
}
