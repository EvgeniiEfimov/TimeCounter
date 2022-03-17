//
//  TableViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import RealmSwift
import SPAlert

class TableDateCellViewController: UITableViewController {

    private var listInfoOfMonch: Results<ListInfoOfMonch>!
    private let calendar = Calendar.current
    private let imageLunchTrue = UIImage.init(systemName: "fork.knife")
    private let imageLunchFalse = UIImage.init(systemName: "minus")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "backTableImage1"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.alpha = 0.1
        
        listInfoOfMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        
        if listInfoOfMonch.isEmpty {
            alertFirstStart()
        }
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        listInfoOfMonch.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Swift"
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = listInfoOfMonch[section]
        return day.monch.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDate", for: indexPath)
        cell.backgroundColor = UIColor.clear
                
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "dd / MM, EEEE"
        dateFormatterDay.locale = Locale(identifier: "RU_RU")
        
        
        let monch = listInfoOfMonch[indexPath.section]
        let daySorted = monch.monch.sorted(byKeyPath: "dateWorkShift")
        let day = daySorted[indexPath.row]
//        monch.monch[indexPath.row]
        
//        let lunch = day.lunchBool ? imageLunchTrue : imageLunchFalse // <---------------
        var content = cell.defaultContentConfiguration()
        content.text = dateFormatterDay.string(from: day.dateWorkShift)
        content.textProperties.font = UIFont.init(name: "Zapf Dingbats", size: 18.0) ??
            .preferredFont(forTextStyle: .body)
        content.secondaryText = day.timeWorkFormat + String(format: " ~ %.1f ч", day.timeWork)
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .init(red: 0.134, green: 0.128, blue: 0.128, alpha: 0.2)
        
        let header = view as! UITableViewHeaderFooterView
        var content = header.defaultContentConfiguration()
        content.prefersSideBySideTextAndSecondaryText = true
        
        let month = listInfoOfMonch[section]
        content.text = month.nameMonth
        content.secondaryText = timeWorkOfFormatString(allTimeMonch(month)) + String(format: " ~ %.1f ч", allTimeMonch(month))
        content.secondaryTextProperties.font = UIFont.init(name: "Zapf DingBats", size: 20.0)!
        content.secondaryTextProperties.color = .red
        content.textProperties.color = .black
        content.textProperties.font = UIFont.init(name: "Courier", size: 22.0) ?? .preferredFont(forTextStyle: .body)
        header.contentConfiguration = content
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {


        let monch = listInfoOfMonch[indexPath.section]
        let day = monch.monch[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.deleteMonch(monch: day)
            if monch.monch.count == 0 {
                StorageManager.shared.deleteMonch(allMonch: monch)
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                self.spAlert()
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                self.spAlert()

            }

        }

        return UISwipeActionsConfiguration(actions: [deleteAction])

    }
//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addVC" {
            if let addJobDateVC = segue.destination as? AddJobDateViewController {
                addJobDateVC.saveCompletion = {
                    self.tableView.reloadData()
        }
            }} else if segue.identifier == "detailVC" {
               if let detailedVC = segue.destination as? DetailedInformationViewController {
                    guard let indexPath = tableView.indexPathForSelectedRow else {
                        return
                    }

                   let month = listInfoOfMonch[indexPath.section]
                   let sortDay = month.monch.sorted(byKeyPath: "dateWorkShift")
                   let day = sortDay[indexPath.row]
                   let infoOfDay = day.day
                   
                    detailedVC.info = infoOfDay
            }

            }
//        else if segue.identifier == "settingsVC" {
//                if let settingsVC = segue.destination as? SettingsViewController {
//                    settingsVC.saveCompletionSettings = {
//                        self.tableView.reloadData()
//
//            }
//                }
//            else { return }
//                
//            }
    }
            
 
   
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
//    private func readDataAndUpdateUI() {
//        jobDataList = StorageManager.shared.realm.objects(InfoOfDayWork.self).sorted(byKeyPath: "dateWorkShift")
//        self.setEditing(false, animated: true)
//        self.tableView.reloadData()
//    }
    
    @IBAction func deleteAllAction(_ sender: UIBarButtonItem) {
        alertDeleteAll()
    }
    
    
    func alertDeleteAll() {
        let alertDelete = UIAlertController.init(title: "Удалить все записанные смены?",
                                                message: "Вы действительно хотите удалить все записанные смены без возможности восстановления?",
                                                preferredStyle: .alert)
        alertDelete.addAction(.init(title: "Да",
                                    style: .destructive,
                                    handler: { (UIAlertAction) in
                                        StorageManager.shared.deleteAllListInfo()
            self.tableView.reloadData()
                                    }))
        alertDelete.addAction(.init(title: "Нет",
                                    style: .default,
                                    handler: nil))
        
        present(alertDelete,
                animated: true,
                completion: nil)
    }
    
    func alertFirstStart() {
        let alertStart = UIAlertController(title: "Привет!",
                                           message: """
Краткая инструкция:
* Для добавления смены воспользуйтесь иконкой ➕ в правом верхнем углу
* Для удаления конкретной смены воспользуйтесь свайпом  👈🏻 влево на необходимой ячейки
* Иконка корзины 🗑 в левом верхнем углу служит для удаления всех смен (без возможности возврата!)
* ⚙️ позволит настроить учет обеденного перерыва и часовую ставку
* ВНИМАНИЕ! Данное приложение носит исключительно информативный характер и предназначено для
более удобного отслеживания рабочих часов. Все расчеты являются приблизительными и в настоящее время
не учитывают доплату за ночные часы и премии
""",
                                           preferredStyle: .alert)
        alertStart.addAction(.init(title: "Понятно!",
                                   style: .default,
                                   handler: nil))
        present(alertStart, animated: true, completion: nil)
    }
    
    private func spAlert() {
        let alertView = SPAlertView(title: "Удалено", preset: .error)
        alertView.duration = 1.3
        alertView.cornerRadius = 12
        alertView.present()
        alertView.backgroundColor = UIColor.darkGray
    }
}

extension TableDateCellViewController {
    func allTimeMonch(_ monch: ListInfoOfMonch) -> Double {
        var allTimeMonch = 0.0
        for timeDay in monch.monch {
            allTimeMonch += timeDay.timeWork
        }
        return allTimeMonch
    }
    
    func timeWorkOfFormatString(_ timeInterval: Double) -> String {
    let formatter = DateComponentsFormatter()
        formatter.calendar?.locale = Locale(identifier: "Ru-ru")
    formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated

        let formattedString = formatter.string(from: TimeInterval(timeInterval * 3600.0))
        return formattedString ?? "-"
    }
    
}
