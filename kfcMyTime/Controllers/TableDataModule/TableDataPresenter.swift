//
//  TableDataPresenter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 08.08.2022.
//

import Foundation

protocol TableDataPresenterProtocol: AnyObject {
    func swipeCellLeft(_ indexPath: IndexPath)
    func deleteSection(_ indexPath: IndexPath)
    func deleteRow(_ indexPath: IndexPath)
    func showSpAlert(_ text: String)
    func seque(_ seque: Transition)
    
    var configureViewData: [ListInfoOfMonch] { get }
    var configureViewSettings: SettingRateAndFormatDate { get }
}

class TableDataPresenter: TableDataPresenterProtocol {
    
    weak var view: TableDataViewControllerProtocol!
    var interactor: TableDataInteractorProtocol!
    var router: TableDataRouterProtocol!
    
    required init(view: TableDataViewControllerProtocol) {
        self.view = view
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
    
    func seque(_ seque: Transition) {
        router.prepare(for: seque.segue, sender: seque.sender)
    }
    
    
    var configureViewData: [ListInfoOfMonch] {
        interactor.startInfo
    }
    
    var configureViewSettings: SettingRateAndFormatDate {
        interactor.settingsView
    }
}
