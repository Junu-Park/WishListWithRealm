//
//  WishRepository.swift
//  WishListWithRealm
//
//  Created by 박준우 on 3/5/25.
//

import Foundation

import RealmSwift

protocol WishRepositoryInterface {
    func checkLocation()
    func fetchWishList() -> Results<Wish>
    func fetchWishListInFolder(folderID: ObjectId) -> List<Wish>
    func createWish(title: String)
    func createWishInFolder(folderID: ObjectId, title: String)
    func deleteWish(wish: Wish)
}

final class WishRepository: WishRepositoryInterface {
    private let realm: Realm = try! Realm()
    
    func checkLocation() {
        print(self.realm.configuration.fileURL ?? "경로 확인 불가")
    }
    
    func fetchWishList() -> Results<Wish> {
        return self.realm.objects(Wish.self)
    }
    
    func fetchWishListInFolder(folderID: ObjectId) -> List<Wish> {
        guard let folder = self.realm.objects(Folder.self).where({ $0.id == folderID }).first else {
            return List()
        }
        return folder.wishList
    }
    
    func createWish(title: String) {
        do {
            try self.realm.write {
                let newWish = Wish(title: title, content: "내용입니다.")
                self.realm.add(newWish)
            }
        } catch {
            print("Wish 생성 실패")
        }
    }
    
    func createWishInFolder(folderID: ObjectId, title: String) {
        do {
            try self.realm.write {
                guard let folder = self.realm.objects(Folder.self).where({ $0.id == folderID }).first else {
                    return
                }
                let newWish = Wish(title: title, content: "내용입니다.")
                folder.wishList.append(newWish)
            }
        } catch {
            print("Wish 생성 실패")
        }
    }
    
    func deleteWish(wish: Wish) {
        do {
            try self.realm.write {
                self.realm.delete(wish)
            }
        } catch {
            print("Wish 삭제 실패")
        }
    }
}
