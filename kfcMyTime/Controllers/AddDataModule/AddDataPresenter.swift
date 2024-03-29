//
//  AddDataPresenter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 11.08.2022.
//

import Foundation

protocol AddDataPresenterProtocol: AnyObject {
    func pressSaveButton(_ data: AddDataStruct)
    func showAlert(_ alert: Alert)
    func showSpAlert()
    var dismissView: Bool { get }
}

class AddDataPresenter: AddDataPresenterProtocol {

    weak var view: AddDataViewProtocol!
    var interactor: AddDataInteractorProtocol!
    var router: AddDataRouterProtocol!

    
    required init(view: AddDataViewProtocol) {
        self.view = view
    }
    
    func pressSaveButton(_ data: AddDataStruct) {
        interactor.saveData(data)
    }
    
    func showAlert(_ alert: Alert) {
        view.showAlert(alert)
    }
    
    func showSpAlert() {
        view.spAlert()
    }
    
    var dismissView: Bool {
        get {
            router.dismissVC()
            return true
        }
    }
}
