//
//  DetailedInformationPresentor.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 31.07.2022.
//

import Foundation

protocol DetailedInformationPresenterProtocol: AnyObject {
    func configureView(_ indexPathSection: Int, _ indexPathRow: Int)
}

class DetailedInformationPresenter : DetailedInformationPresenterProtocol {
  
    weak var view: DetailedInformationViewProtocol!
    var interactor: DetailedInformationInteractorProtocol!
    
    required init(view: DetailedInformationViewProtocol) {
        self.view = view
    }
    
    func configureView(_ indexPathSection: Int, _ indexPathRow: Int) {
        view.setInfo(with:(interactor.getInfoDay(indexPathSection, indexPathRow)))
    }
    
    
}
