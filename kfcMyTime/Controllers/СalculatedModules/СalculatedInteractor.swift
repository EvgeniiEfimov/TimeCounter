//
//  СalculatedInteractor.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 18.08.2022.
//

import Foundation

protocol CalculatedInteractorProtocol: AnyObject {
    var getListInfoOfMonth: [ListInfoOfMonch] { get }
}

final class CalculatedInteractor: CalculatedInteractorProtocol {
    weak var presenter: CalculatedPresenterProtocol!
    let dataService: DataServiceProtocol = DataService()
    
    required init(presenter: CalculatedPresenterProtocol) {
        self.presenter = presenter
    }
    var getListInfoOfMonth: [ListInfoOfMonch] {
        var array: [ListInfoOfMonch] = []
        for valueData in dataService.listInfoOfMonch {
            array.append(valueData)
        }
        return array
    }

}
