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
    
    func saveListInfo(infoList: ListInfoDate) {
        write {
            realm.add(infoList)
        }
    }
    
    func deleteListInfo(infoList: ListInfoDate) {
        write {
            realm.delete(infoList)
//            realm.delete(infoList.info)
        }
    }
    
    func deleteAllListInfo() {
        write {
            realm.deleteAll()
        }
    }
    
    
    func saveSettings(settings: SettingsUser) {
        write {
            realm.add(settings)
        }
    }
    
    func deleteSettings(settings: SettingsUser) {
        write {
            realm.delete(settings)
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
