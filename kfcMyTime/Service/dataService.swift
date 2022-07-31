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
    var listInfoOfMonch: Results<ListInfoOfMonch>! {get}
}

class DataService: DataServiceProtocol {
    
    let realm = try! Realm()
    
    var listInfoOfMonch: Results<ListInfoOfMonch>!
    
    func info(_ indexPathSection: Int, _ indexPathRow: Int) -> InfoOfDayWork? {
        listInfoOfMonch = realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        let monch = listInfoOfMonch[indexPathSection]
        /// Сортировка массива дней месяца
        let daySorted = monch.monch.sorted(byKeyPath: "dateWorkShift")
        /// Определение дня
        let day = daySorted[indexPathRow]
        return day.day
    }
}
