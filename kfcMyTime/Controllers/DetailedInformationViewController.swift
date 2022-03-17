//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import RealmSwift

class DetailedInformationViewController: UIViewController {

    var listInfo: Results<InfoOfDayWork>!
    var info: InfoOfDayWork!
    var lunchTime: String = ""
    var boolValueOfLunch: Bool!
    var dateFormatter = DateFormatterClass()
    
    
    @IBOutlet weak var dateWorkOutlet: UILabel!
    @IBOutlet weak var startTimeWorkOutlet: UILabel!
    @IBOutlet weak var finishTimeWorkOutlet: UILabel!
    @IBOutlet weak var lanchTimeOutlet: UILabel!
    @IBOutlet weak var workTimeOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView()
    }
    
//    private func calculationLunchTimeMinute(_ lunch: Double) -> String {
//        switch lunch {
//        case 0.8:
//            return "45'"
//        case 0.5:
//            return "30'"
//        default:
//            return "0"
//        }
//    }
    
    
    
    private func loadingView() {
        dateWorkOutlet.text = dateFormatter.dayDateFormatter(info.dateWorkShift)
        startTimeWorkOutlet.text = dateFormatter.timeDateFormatter(info.timeStart)
        finishTimeWorkOutlet.text = dateFormatter.timeDateFormatter(info.timeStop)
        lanchTimeOutlet.text = info.lunchString
        workTimeOutlet.text = info.timeWorkString
    }
}


