//
//  СalculatedPresenter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 18.08.2022.
//

import Foundation

protocol CalculatedPresenterProtocol: AnyObject {
    func configureView()
    func clickButtonCalculate(_ valuePickerView: Int, _ indexSegmentedControl: Int)
    func showAlert(_ alert: Alert)
    func saveRate(_ rate: String)
    func calculateValue(_ allTime: String,_ money: String)
}

final class CalculatedPresenter: CalculatedPresenterProtocol {
    weak var view: CalculatedViewControllerProtocol!
    var interactor: CalculatedInteractorProtocol!
    var router: CalculatedRouterProtocol!
    
    required init(view: CalculatedViewControllerProtocol) {
        self.view = view
    }
    
    func configureView() {
        view.setListInfoOfMonch(interactor.getArrayNameOfMonth)
    }
    
    func clickButtonCalculate(_ valuePickerView: Int, _ indexSegmentedControl: Int) {
        interactor.calculated(valuePickerView, indexSegmentedControl)
    }
    
    func showAlert(_ alert: Alert) {
        view.showAlert(alert)
    }
    
    func saveRate(_ rate: String) {
        interactor.saveRate(rate)
    }
    
    func calculateValue(_ allTime: String,_ money: String) {
        view.setOutle(allTime, money)
    }
}
