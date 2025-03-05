//
//  WishListViewController.swift
//  WishListWithRealm
//
//  Created by 박준우 on 3/5/25.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SnapKit

final class WishListViewController: BaseViewController {

    private let tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    private let folderRepo: FolderRepositoryInterface = FolderRepository()
    private let wishRepo: WishRepositoryInterface = WishRepository()
    var folderID: ObjectId!
    private let publishRelay: PublishRelay<List<Wish>> = PublishRelay()
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.folderRepo.checkLocation()
    }
    
    override func configureHierarchy() {
        self.view.addSubview(self.tableView)
    }
    
    override func configureLayout() {
        self.tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        guard let data = self.folderRepo.fetchFolder().where({ $0.id == self.folderID }).first else {
            self.navigationItem.title = "데이터 읽어오기 실패"
            return
        }
        self.navigationItem.title = data.name
        
        let sc = UISearchController()
        sc.hidesNavigationBarDuringPresentation = false
        self.navigationItem.searchController = sc
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func bind() {
        self.publishRelay
            .bind(to: self.tableView.rx.items(cellIdentifier: "cell")) { row, data, cell in
                var config = cell.defaultContentConfiguration()
                config.text = data.title
                
                cell.contentConfiguration = config
            }
            .disposed(by: self.disposeBag)
        
        let wishList = self.wishRepo.fetchWishListInFolder(folderID: self.folderID)
        self.publishRelay.accept(wishList)
        
        self.navigationItem.searchController?.searchBar.rx.searchButtonClicked
            .withLatestFrom(self.navigationItem.searchController!.searchBar.rx.text.orEmpty.distinctUntilChanged())
            .bind(with: self, onNext: { owner, value in
                owner.wishRepo.createWishInFolder(folderID: owner.folderID, title: value)
                
                let wishList = owner.wishRepo.fetchWishListInFolder(folderID: owner.folderID)
                owner.publishRelay.accept(wishList)
            })
            .disposed(by: self.disposeBag)
    }
}
