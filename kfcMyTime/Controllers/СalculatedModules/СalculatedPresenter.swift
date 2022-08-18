//
//  СalculatedPresenter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 18.08.2022.
//

import Foundation

protocol CalculatedPresenterProtocol: AnyObject {
    func configureView()
}

final class CalculatedPresenter: CalculatedPresenterProtocol {
    weak var view: CalculatedViewControllerProtocol!
    var interactor: CalculatedInteractorProtocol!
    var router: CalculatedRouterProtocol!
    
    required init(view: CalculatedViewControllerProtocol) {
        self.view = view
    }
    
    func configureView() {
        view.setListInfoOfMonch(interactor.getListInfoOfMonth)
    }
   
}
