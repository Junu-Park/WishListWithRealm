//
//  BaseViewController.swift
//  WishListWithRealm
//
//  Created by 박준우 on 3/5/25.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configureHierarchy()
        self.configureLayout()
        self.configureView()
        self.bind()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    func bind() { }
}
