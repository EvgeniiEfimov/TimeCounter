//
//  DetailedInformationInteractor.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 31.07.2022.
//

import Foundation

protocol DetailedInformationInteractorProtocol: AnyObject {
    func getInfoDay(_ indexPathSection: Int, _ indexPathRow: Int) -> InfoOfDayWork?
}

class DetailedInformationInteractor: DetailedInformationInteractorProtocol {
 
    weak var presenter: DetailedInformationPresenterProtocol!
    let dataService: DataServiceProtocol = DataService()
    required init(presenter: DetailedInformationPresenterProtocol) {
        self.presenter = presenter
}
    func getInfoDay(_ indexPathSection: Int, _ indexPathRow: Int) -> InfoOfDayWork? {
        dataService.info(indexPathSection, indexPathRow)
    }
}
