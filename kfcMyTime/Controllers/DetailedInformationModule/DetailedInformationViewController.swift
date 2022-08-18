//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import UIKit

protocol DetailedInformationViewProtocol: AnyObject {
    func setInfo(with data: InfoOfDayWork?)
}

class DetailedInformationViewController: UIViewController {
    
    var presenter: DetailedInformationPresenterProtocol!
    let configurator: DetailedInformationConfiguratorProtocol = DetaileedInformationConfigurator()
    
    //MARK: - Outlets
    @IBOutlet weak var dateWorkOutlet: UILabel!
    @IBOutlet weak var startTimeWorkOutlet: UILabel!
    @IBOutlet weak var finishTimeWorkOutlet: UILabel!
    @IBOutlet weak var lanchTimeOutlet: UILabel!
    @IBOutlet weak var workTimeOutlet: UILabel!
    @IBOutlet weak var workNightTimeOutlet: UILabel!
    @IBOutlet weak var informOutlet: UITextView!
    
    //MARK: - Публичные свойства

    /// Полученный номер секции таблицы
    var indexPathSection: Int!
    /// Полученный номер строки таблицы
    var indexPathRow: Int!
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        presenter.configureView(indexPathSection, indexPathRow)
    }
    
    //MARK: - Приватные методы
    
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

extension DetailedInformationViewController: DetailedInformationViewProtocol {
    func setInfo(with data: InfoOfDayWork?) {
        guard let info = data else {
            dismiss(animated: true)
            return
        }
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
        informOutlet.text = info.inform
    }
}


