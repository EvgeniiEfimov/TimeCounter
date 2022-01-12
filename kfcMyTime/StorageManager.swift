//
//  StorageManager.swift
//  kfcMyTime
//
//  Created by User on 28.10.2021.
//

import RealmSwift

class StorageManager {
    static let shared = StorageManager()
    
    let realm = try! Realm()
    
    private init() {}
    
    func save(infoList: ListInfoDate) {
        write {
            realm.add(infoList)
        }
    }
    
    func delete(infoList: ListInfoDate) {
        write {
            realm.delete(infoList)
//            realm.delete(infoList.info)
        }
    }
    
    func deleteAll() {
        write {
            realm.deleteAll()
        }
    }
    
    private func write (_ completion: () -> Void) {
        do {
            try realm.write {
            completion()
            }
        } catch let error {
            print(error)
        }
    }
}
