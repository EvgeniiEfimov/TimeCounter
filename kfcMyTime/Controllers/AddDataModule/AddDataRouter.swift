//
//  AddDataRouter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 11.08.2022.
//

import Foundation

protocol AddDataRouterProtocol: AnyObject {
    
}

class AddDataRouter: AddDataRouterProtocol {
    weak var view: AddDataViewProtocol!
    
    required init(view: AddDataViewProtocol) {
        self.view = view
    }
}
