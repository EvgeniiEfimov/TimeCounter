//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import RealmSwift

class DetailedInformationViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var dateWorkOutlet: UILabel!
    @IBOutlet weak var startTimeWorkOutlet: UILabel!
    @IBOutlet weak var finishTimeWorkOutlet: UILabel!
    @IBOutlet weak var lanchTimeOutlet: UILabel!
    @IBOutlet weak var workTimeOutlet: UILabel!
    @IBOutlet weak var workNightTimeOutlet: UILabel!
    @IBOutlet weak var inform: UITextView!
    
    //MARK: - Публичные свойства
    /// Объявление свойства хнанения информации о рабочем дне из БД
    var info: InfoOfDayWork!
    /// Объявление и инициализация свойства экземпляром класса
    var dateFormatter = DateFormatterClass()
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Вызов метода инициализации свойств аутлетов полученными значениями
        loadingView()
    }
    
    //MARK: - Приватные методы
    /// Метод инициализации свойств аутлетов полученными значениями
    private func loadingView() {
        dateWorkOutlet.text = info.dateWorkShift
        startTimeWorkOutlet.text = info.timeStart
        finishTimeWorkOutlet.text = info.timeStop
        lanchTimeOutlet.text = info.lunchString
        workTimeOutlet.text =  info.timeWorkString
        workNightTimeOutlet.text = String(format: "%.1f", info.workNightTime)
        inform.text = info.inform
    }
}
extension DetailedInformationViewController {
  
    func timeDateFormatter(_ time: Date, _ dateFormat: String) -> String {
       let dateFormatterTime = DateFormatter()
       dateFormatterTime.dateFormat = dateFormat
       dateFormatterTime.locale = Locale(identifier: "RU_RU")
       return dateFormatterTime.string(from: time)
   }
}


