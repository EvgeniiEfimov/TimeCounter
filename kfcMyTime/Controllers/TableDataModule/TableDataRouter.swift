//
//  TableDataRouter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 08.08.2022.
//

import Foundation
import UIKit

protocol TableDataRouterProtocol: AnyObject {
    func showAddScene()
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
}

class TableDataRouter: TableDataRouterProtocol {
    
    weak var viewController: TableDateViewController!
    
    init(viewController: TableDateViewController) {
        self.viewController = viewController
    }
    
    func showAddScene() {
        viewController.performSegue(withIdentifier: viewController.selfToAddSegueName, sender: nil)
    }
    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
}
