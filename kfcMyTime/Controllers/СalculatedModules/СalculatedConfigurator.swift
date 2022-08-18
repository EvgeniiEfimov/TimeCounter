//
//  СalculatedConfigurator.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 18.08.2022.
//

import Foundation

protocol CalculatedConfiguratorProtocol: AnyObject {
    func configure(viewController: СalculatedViewController)
}

final class CalculatedConfigurator: CalculatedConfiguratorProtocol {
    func configure(viewController: СalculatedViewController) {
        let presenter = CalculatedPresenter(view: viewController)
        let interactor = CalculatedInteractor(presenter: presenter)
        let router = CalculatedRouter(view: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
   
    
    
}
