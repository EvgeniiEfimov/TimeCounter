//
//  TableDataConfigurator.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 08.08.2022.
//

import Foundation

// Конфигуратор модуля TableData
protocol TableDataConfiguratorProtocol: AnyObject {
    func configure(with viewController: TableDateViewController)
}

class TableDataConfigurator: TableDataConfiguratorProtocol {
    func configure(with viewController: TableDateViewController) {
        let presenter = TableDataPresenter(view: viewController)
        let interactor = TableDataInteractor(presenter: presenter)
        let router = TableDataRouter(viewController: viewController)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
