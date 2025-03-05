//
//  Wish.swift
//  WishListWithRealm
//
//  Created by 박준우 on 3/5/25.
//

import Foundation

import RealmSwift

final class Wish: Object {
    @Persisted var id: ObjectId
    @Persisted var title: String
    @Persisted var content: String
    
    convenience init(title: String, content: String) {
        self.init()
        self.title = title
        self.content = content
    }
}
