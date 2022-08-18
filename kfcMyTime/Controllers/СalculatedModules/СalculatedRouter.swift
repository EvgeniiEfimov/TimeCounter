//
//  СalculatedRouter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 18.08.2022.
//

import Foundation

protocol CalculatedRouterProtocol: AnyObject {
    
}

final class CalculatedRouter: CalculatedRouterProtocol {
    weak var view: CalculatedViewControllerProtocol!
    
    required init(view: СalculatedViewController) {
        self.view = view
    }
    
}
