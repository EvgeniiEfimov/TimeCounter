//
//  dataService.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 31.07.2022.
//

import Foundation
import RealmSwift

protocol DataServiceProtocol: AnyObject {
    func info(_ indexPathSection: Int, _ indexPathRow: Int) -> InfoOfDayWork?
    var listInfoOfMonch: Results<ListInfoOfMonch> {get}
    func deleteDayOfMonth(monch: DayOfMonth, in listInfoOfMonch: ListInfoOfMonch)
    func deleteDayInfo(day: InfoOfDayWork)
    func deleteMonch(allMonch: ListInfoOfMonch)
    func saveListInfoOfMonch(allMonch: ListInfoOfMonch)
    func saveDayOfMonch(monch: DayOfMonth, in listInfoOfMonch: ListInfoOfMonch)
}

class DataService: DataServiceProtocol {
    let realm = try! Realm()
    
    var listInfoOfMonch: Results<ListInfoOfMonch> {
        get {
            realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        }
    }
    
    func info(_ indexPathSection: Int, _ indexPathRow: Int) -> InfoOfDayWork? {
        let monch = listInfoOfMonch[indexPathSection]
        /// Сортировка массива дней месяца
        let daySorted = monch.monch.sorted(byKeyPath: "dateWorkShift")
        /// Определение дня
        let day = daySorted[indexPathRow]
        return day.day
    }
    
    func deleteDayOfMonth(monch: DayOfMonth, in listInfoOfMonch: ListInfoOfMonch) {
        write {
            listInfoOfMonch.allWorkTimeOfMonch -= monch.timeWork
            listInfoOfMonch.allNightWorkTime -= monch.day?.workNightTime ?? 0.0
            listInfoOfMonch.allDayWorkTime -= monch.day?.workDayTime ?? 0.0
            realm.delete(monch)
        }
    }
    
    func deleteDayInfo(day: InfoOfDayWork) {
        write {
            realm.delete(day)
        }
    }
    
    func deleteMonch(allMonch: ListInfoOfMonch) {
        write {
            realm.delete(allMonch)
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
    
    //MARK: -saveData
    
    func saveListInfoOfMonch(allMonch: ListInfoOfMonch) {
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
    
    func saveDayOfMonch(monch: DayOfMonth, in listInfoOfMonch: ListInfoOfMonch) {
        write {
            listInfoOfMonch.monch.append(monch)
            listInfoOfMonch.allWorkTimeOfMonch += monch.timeWork
            listInfoOfMonch.allNightWorkTime += monch.day?.workNightTime ?? 0.0
            listInfoOfMonch.allDayWorkTime += monch.day?.workDayTime ?? 0.0
        }
    }
}
