//
//  Folder.swift
//  WishListWithRealm
//
//  Created by 박준우 on 3/5/25.
//

import Foundation

import RealmSwift

final class Folder: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var wishList: List<Wish>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
