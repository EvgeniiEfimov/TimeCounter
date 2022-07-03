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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Приватные методы
    /// Метод инициализации свойств аутлетов полученными значениями
    private func loadingView() {
        animatedLabel(dateWorkOutlet, 1)
        dateWorkOutlet.text = info.dateWorkShift
        animatedLabel(startTimeWorkOutlet, 2)
        startTimeWorkOutlet.text = info.timeStart
        animatedLabel(finishTimeWorkOutlet, 3)
        finishTimeWorkOutlet.text = info.timeStop
        animatedLabel(lanchTimeOutlet, 4)
        lanchTimeOutlet.text = info.lunchString
        animatedLabel(workTimeOutlet, 5)
        workTimeOutlet.text =  info.timeWorkString
        animatedLabel(workNightTimeOutlet, 6)
        workNightTimeOutlet.text = String(format: "%.1f", info.workNightTime)
        inform.text = info.inform
    }
    
    private func animatedLabel(_ label: UILabel, _ time: Double) {
        let direction = -view.bounds.height
        label.transform = CGAffineTransform(translationX: direction, y: direction)
        UIView.animate(withDuration: 0.4,
                       delay: time * 0.05,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut,
                       animations: { label.transform = CGAffineTransform.identity})
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


