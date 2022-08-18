//
//  AddJobDateViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import UIKit
import SPAlert


protocol AddDataViewProtocol: AnyObject {
    func showAlert(_ alert: Alert)
    func spAlert()
    func dismissView()
}

class AddJobDateViewController: UIViewController, UITextFieldDelegate, AddDataViewProtocol {
    
    //MARK: - Outlets
    @IBOutlet weak var addButtonOutlet: UIButton!
    @IBOutlet weak var switchOfLunch: UISwitch!
    @IBOutlet weak var switchOfNightTime: UISwitch!
    @IBOutlet weak var startTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var stopTimeJobOutlet: UIDatePicker!
    @IBOutlet weak var infoTF: UITextField!
    
    //MARK: - Приватные свойства
    private let secondsPerHour = 3600.0
    
    //MARK: - Публичные свойства
    var saveCompletion: (() -> Void)?
    var presenter: AddDataPresenterProtocol!
    let configurator: AddDataConfiguratorProtocol = AddDataConfigurator()
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        infoTF.delegate = self
    }
    
    //MARK: - Action
    @IBAction func infoOfLunchAction(_ sender: UIButton) {
    }
    
    @IBAction func saveButtonAction() {
        let data = AddDataStruct(note: infoTF.text,
                                   timeStart: startTimeJobOutlet.date,
                                   timeStop: stopTimeJobOutlet.date,
                                   lunch: switchOfLunch.isOn,
                                   nightTime: switchOfNightTime.isOn)
        
        presenter.pressSaveButton(data)
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
               if sender.isOn == true {
                   sender.tintColor = UIColor.systemYellow
                   sender.thumbTintColor = UIColor.darkGray
               } else {
                   sender.tintColor = UIColor.darkGray
                   sender.thumbTintColor = UIColor.systemOrange
               }
       }

    func showAlert(_ alert: Alert) {
        let alertError = UIAlertController.init(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertError.addAction(.init(title: alert.buttonTitleFirst,
                                   style: .default,
                                   handler: nil))
        present(alertError,
                animated: true,
                completion: nil)
    }
    
     func spAlert() {
        let alertView = SPAlertView(title: "Добавлено", preset: .done)
        alertView.duration = 1.3
        alertView.cornerRadius = 12
        alertView.present()
        alertView.backgroundColor = UIColor.darkGray
    }
    
     func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissView() {
        dismiss(animated: true, completion: saveCompletion)
    }

}
    

