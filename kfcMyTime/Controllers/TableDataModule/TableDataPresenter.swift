//
//  TableDataPresenter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 08.08.2022.
//

import Foundation

protocol TableDataPresenterProtocol: AnyObject {
    func configureView()
    func swipeCellLeft(_ indexPath: IndexPath)
    func deleteSection(_ indexPath: IndexPath)
    func deleteRow(_ indexPath: IndexPath)
    func showSpAlert(_ text: String)
    func addButtonAction()
}

class TableDataPresenter: TableDataPresenterProtocol {
    
    weak var view: TableDataViewControllerProtocol!
    var interactor: TableDataInteractorProtocol!
    var router: TableDataRouterProtocol!
    
    required init(view: TableDataViewControllerProtocol) {
        self.view = view
    }
    
    func configureView() {
        view.setView(with: interactor.startInfo)
        view.setSetting(with: interactor.settingsView)
    }
    
    func swipeCellLeft(_ indexPath: IndexPath) {
        interactor.deleteDay(indexPath)
    }
    
    func deleteSection(_ indexPath: IndexPath) {
        view.tableViewDeleteSection(indexPath)
    }
    
    func deleteRow(_ indexPath: IndexPath) {
        view.tableViewDeleteRow(indexPath)
    }
    
    func showSpAlert(_ text: String) {
        view.showSpAlert(text)
    }
    
    func addButtonAction() {
        router.showAddScene()
    }
}
