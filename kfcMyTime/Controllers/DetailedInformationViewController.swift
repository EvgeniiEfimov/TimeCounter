//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import RealmSwift

class DetailedInformationViewController: UIViewController {

    var listInfo: Results<ListInfoDate>!
    var info: ListInfoDate!
    
    @IBOutlet weak var dateWorkOutlet: UILabel!
    @IBOutlet weak var startTimeWorkOutlet: UILabel!
    @IBOutlet weak var finishTimeWorkOutlet: UILabel!
    @IBOutlet weak var lanchTimeOutlet: UILabel!
    @IBOutlet weak var workTimeOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView()
//        startTimeWorkOutlet.text = "\(String(describing: info.info?.timeStart))"
    }
    
    private func timeDateFormatter(_ time: Date) -> String {
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm"
        dateFormatterTime.locale = Locale(identifier: "RU_RU")
        return dateFormatterTime.string(from: time)
    }
    
    private func dayDateFormatter(_ day: Date) -> String  {
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "dd.MM.yy"
        dateFormatterDay.locale = Locale(identifier: "RU_RU")
        return dateFormatterDay.string(from: day)
    }
    
    private func calculationLunchTimeMinute(_ lunch: Double) -> String {
        switch lunch {
        case 0.8:
            return "45'"
        case 0.5:
            return "30'"
        default:
            return "0"
        }
    }
    
    private func loadingView() {
        dateWorkOutlet.text = dayDateFormatter(info.dateWorkShift)
        startTimeWorkOutlet.text = timeDateFormatter(info.timeStart)
        finishTimeWorkOutlet.text = timeDateFormatter(info.timeStop)
        lanchTimeOutlet.text = calculationLunchTimeMinute(info.lunch)
        workTimeOutlet.text = String(info.timeWork)
    }
}

