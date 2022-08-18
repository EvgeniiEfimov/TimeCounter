//
//  TableDataRouter.swift
//  kfcMyTime
//
//  Created by Евгений Ефимов on 08.08.2022.
//

import UIKit

protocol TableDataRouterProtocol: AnyObject {
    func prepare(for segue: UIStoryboardSegue, sender: Any?)
//    func showAddScene()
}

class TableDataRouter: TableDataRouterProtocol {
    
    weak var viewController: TableDateViewController!
    
    init(viewController: TableDateViewController) {
        self.viewController = viewController
    }
    
     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Проверка идентификатора контроллера перехода
         if segue.identifier == "addVC" {
            /// Проверка приведения seque к требуемуему VC
            if let addJobDateVC = segue.destination as? AddJobDateViewController {
                /// Комплишн
                addJobDateVC.saveCompletion = {
                    /// Вызов метода обновления данных таблицы
                    self.viewController.tableView.scrollToBottom()
                    self.viewController.animationCell()
                }
            }
        } else if segue.identifier == "detailVC" {
            /// Проверка приведения seque к требуемуему VC
            if let detailedVC = segue.destination as? DetailedInformationViewController {
                /// Определение свойства indexPath как номер строки таблицы
                guard let indexPath = viewController.tableView.indexPathForSelectedRow else { return }
                detailedVC.indexPathSection = indexPath.section
                detailedVC.indexPathRow = indexPath.row
            }
        }
    }
}
