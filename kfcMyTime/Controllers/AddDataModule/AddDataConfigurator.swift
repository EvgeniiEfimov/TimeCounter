//
//  AddDataConfigurator.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 11.08.2022.
//

import Foundation
import UIKit

protocol AddDataConfiguratorProtocol: AnyObject {
    func configure(with viewController: AddJobDateViewController)
}

class AddDataConfigurator: AddDataConfiguratorProtocol {
    
    func configure(with viewController: AddJobDateViewController) {
        let presenter = AddDataPresenter(view: viewController)
        let interactor = AddDataInteractor(presenter: presenter)
        let router = AddDataRouter(view: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
    
}
