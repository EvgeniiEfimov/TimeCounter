//
//  ViewController.swift
//  kfcMyTime
//
//  Created by User on 29.01.2022.
//

import UIKit

protocol CalculatedViewControllerProtocol: AnyObject {
    func setListInfoOfMonch(_ stringArray: [String])
    func showAlert(_ alert: Alert)
    func setOutle(_ setAllTimeRangeDayOutlet: String,_ setAmountLabelOutlet: String)
}

class СalculatedViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var periodSCOutlet: UISegmentedControl!
    @IBOutlet weak var monthPickerView: UIPickerView!
    @IBOutlet weak var allTimeRangeDayOutlet: UILabel!
    @IBOutlet weak var amountLabelOutlet: UILabel!
    @IBOutlet weak var buttonCalculatedOutlet: UIButton!
    
    private var monthNameArray: [String]!
    
    //MARK: - Приватные свойства
    private var rateTF: String = ""
    private let monthNumber = Calendar.current.dateComponents([.month], from: Date())
    
    var presenter: CalculatedPresenterProtocol!
    var configurator: CalculatedConfiguratorProtocol = CalculatedConfigurator()
    
    //MARK: - Методы переопределения родительского класса
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(viewController: self)
        monthPickerView.dataSource = self
        monthPickerView.delegate = self
        /// Вызов метода стартовых настроек view
        startSetView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter.configureView()
        
        if monthNameArray.isEmpty {
            buttonCalculatedOutlet.isUserInteractionEnabled = false
            buttonCalculatedOutlet.alpha = 0.5
            allTimeRangeDayOutlet.isHidden = true
            amountLabelOutlet.isHidden = true
            monthPickerView.reloadAllComponents()
        } else {
            buttonCalculatedOutlet.isUserInteractionEnabled = true
            buttonCalculatedOutlet.alpha = 1
            allTimeRangeDayOutlet.isHidden = true
            amountLabelOutlet.isHidden = true
            monthPickerView.reloadAllComponents()
        }
        monthPickerView.selectRow(monthNameArray.count - 1, inComponent: 0, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Actions
    
    @IBAction func button() {
        presenter.clickButtonCalculate(monthPickerView.selectedRow(inComponent: 0),
                                       periodSCOutlet.selectedSegmentIndex)
    }
    
    //MARK: - Приватные методы
    private func startSetView() {
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.systemYellow]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.darkGray]
        periodSCOutlet.setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
    }
}

//MARK: - Расширения класса
extension СalculatedViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numberOfRows = 1
        presenter.configureView()
        if !monthNameArray.isEmpty {
            numberOfRows = monthNameArray.count
        }
        return numberOfRows
    }
}

extension СalculatedViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var returnString = "Нет данных"
        if !monthNameArray.isEmpty {
            returnString = monthNameArray[row]
        }
        return returnString
    }
}


extension СalculatedViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        rateTF = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        button()
        return true
    }
}


extension СalculatedViewController: CalculatedViewControllerProtocol {
    func setListInfoOfMonch(_ stringArray: [String]) {
        monthNameArray = stringArray
    }
    
    func showAlert(_ alert: Alert) {
        let alertError = UIAlertController.init(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertError.addTextField { (textField) in
            textField.placeholder = "Рублей / час"
            self.rateTF = textField.text ?? "10"
            textField.delegate = self
        }
        
        alertError.addAction(.init(title: alert.buttonTitleFirst,
                                   style: .default,
                                   handler:{ action in
            self.presenter.saveRate(self.rateTF)
        }
                                  ))
        
        present(alertError,
                animated: true,
                completion: nil)
    }
    
    func setOutle(_ setAllTimeRangeDayOutlet: String,_ setAmountLabelOutlet: String) {
        allTimeRangeDayOutlet.isHidden = false
        amountLabelOutlet.isHidden = false
        allTimeRangeDayOutlet.text = setAllTimeRangeDayOutlet
        amountLabelOutlet.text = setAmountLabelOutlet
    }
}

