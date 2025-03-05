//
//  FolderRepository.swift
//  WishListWithRealm
//
//  Created by 박준우 on 3/5/25.
//

import Foundation

import RealmSwift

protocol FolderRepositoryInterface {
    func fetchFolder() -> Results<Folder>
    func createFolder(name: String)
    func deleteFolder(folder: Folder)
}

final class FolderRepository: FolderRepositoryInterface {
    private let realm: Realm = try! Realm()
    
    func fetchFolder() -> Results<Folder> {
        return self.realm.objects(Folder.self)
    }
    
    func createFolder(name: String) {
        do {
            try self.realm.write {
                let newFolder = Folder(name: name)
                self.realm.add(newFolder)
            }
        } catch {
            print("폴더 생성 실패")
        }
    }
    
    func deleteFolder(folder: Folder) {
        do {
            try self.realm.write {
                self.realm.delete(folder)
            }
        } catch {
            print("폴더 삭제 실패")
        }
    }
}
