//
//  DetailedInformationConfigurator.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 31.07.2022.
//

import Foundation

// Конфигуратор модуля DetailedInformation
protocol DetailedInformationConfiguratorProtocol: AnyObject {
    func configure(with viewController: DetailedInformationViewController)
}

class DetaileedInformationConfigurator: DetailedInformationConfiguratorProtocol {
func configure(with viewController: DetailedInformationViewController) {
    let presenter = DetailedInformationPresenter(view: viewController)
    let interactor = DetailedInformationInteractor(presenter: presenter)
    
    viewController.presenter = presenter
    presenter.interactor = interactor
}
}

