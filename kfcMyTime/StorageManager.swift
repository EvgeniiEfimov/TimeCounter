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
    
    //MARK: - work ListInfoOfMonch
    func save(allMonch: ListInfoOfMonch) {
        write {
            var allTime = Double()
            var nightWorkTime = Double()
            var dayWorkTime = Double()
            for time in allMonch.monch {
                allTime += time.timeWork
                nightWorkTime += time.day?.workNightTime ?? 0.0
                dayWorkTime += time.day?.workDayTime ?? 0.0
            }
            allMonch.allWorkTimeOfMonch = allTime
            allMonch.allNightWorkTime = nightWorkTime
            allMonch.allDayWorkTime = dayWorkTime
            realm.add(allMonch)
        }
    }
    
    func deleteMonch(allMonch: ListInfoOfMonch) {
        write {

            realm.delete(allMonch)
        }
    }
    
    func deleteAllListInfo() {
        write {
            realm.deleteAll()
        }
    }
    
    //MARK: - Work DayOfMonth
    
    func save(monch: DayOfMonth, in listInfoOfMonch: ListInfoOfMonch) {
        write {
            listInfoOfMonch.monch.append(monch)
            listInfoOfMonch.allWorkTimeOfMonch += monch.timeWork
            listInfoOfMonch.allNightWorkTime += monch.day?.workNightTime ?? 0.0
            listInfoOfMonch.allDayWorkTime += monch.day?.workDayTime ?? 0.0
        }
    }
    
    func deleteMonch(monch: DayOfMonth, in listInfoOfMonch: ListInfoOfMonch) {
        write {
            listInfoOfMonch.allWorkTimeOfMonch -= monch.timeWork
            listInfoOfMonch.allNightWorkTime -= monch.day?.workNightTime ?? 0.0
            listInfoOfMonch.allDayWorkTime -= monch.day?.workDayTime ?? 0.0
            realm.delete(monch)
        }
    }
    
    //MARK: - InfoOfDayWork
    
    func save(day: InfoOfDayWork, in dayOfMonth: DayOfMonth, in listInfoOfMonch: ListInfoOfMonch) {
        write {
            let monch = dayOfMonth
            listInfoOfMonch.monch.append(monch)
        }
    }
    
    func deleteDayInfo(day: InfoOfDayWork) {
        write {
            realm.delete(day)
        }
    }
    
    //MARK: - SettingsRate
    
    func saveSettingsRate (rate: SettingRateAndFormatDate) {
        write {
            realm.add(rate)
        }
    }
    
    //MARK: - SettingsNotification
    
    func saveSettingsNotification (settings: SettingNotification) {
        write {
            realm.add(settings)
        }
    }
    
    
    func deleteSettingsNotification (settings: SettingNotification) {
        write {
            realm.delete(settings)
        }
    }
    
    //MARK: - SettingNightTime
    
    func saveSettingsOfNightTime (settings: SettingNightTime) {
        write {
            realm.add(settings)
        }
    }
    
    
    func deleteSettingsOfNightTime (settings: SettingNightTime) {
        write {
            realm.delete(settings)
        }
    }
    
    //MARK: - SettingRate
    
    func saveSettingRate (settings: SettingRateAndFormatDate) {
        write {
            realm.add(settings)
        }
    }
    
    
    func deleteSettingRate (settings: SettingRateAndFormatDate) {
        write {
            realm.delete(settings)
        }
    }
    
    
     func write (_ completion: () -> Void) {
        do {
            try realm.write {
            completion()
            }
        } catch let error {
            print(error)
        }
    }
}

