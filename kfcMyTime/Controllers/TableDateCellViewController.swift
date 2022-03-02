//
//  TableViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import RealmSwift

class TableDateCellViewController: UITableViewController {

    
    var jobDataLists: ListInfoDate!
    var countRows: Results<ListInfoDate>!
    var sortDate2: Results<ListInfoDate>!
    
    var valueSettingsOfLunchtime = StorageManager.shared.realm.objects(SettingsUser.self)
    
    
    lazy var arrayMonchFiltr = [Results<ListInfoDate>]()
    var arrayMonthFiltr2 = [Int : [ListInfoDate]]()
    
    private var jobDataList: Results<ListInfoDate>!
    
    private var arrayJobDataList = [Results<ListInfoDate>]()
    
    private let monthName = DataManager.shared.monthArray
    private let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "backTableImage1"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.alpha = 0.1
        readDataAndUpdateUI()
        if jobDataList.isEmpty {
            alertFirstStart()
        }
        }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        sortDataToMonth2()
        return arrayJobDataList.count
        
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Swift"
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dayOfMonth = arrayJobDataList[section]
        return dayOfMonth.count
    }

    
    
    private func sortDataToMonth2() {
        var filtrDate: Results<ListInfoDate>!
        arrayJobDataList.removeAll()
        for value in 1...12 {
            filtrDate = jobDataList.filter("month = \(value)")
            if filtrDate.count != 0 {
                if !arrayJobDataList.contains(filtrDate) {
            arrayJobDataList.append(filtrDate)
                }
            }
        }
    }
    
        private func sortDataToMonth(_ monthDay: Int) -> Results<ListInfoDate>! {
    var filtrDate: Results<ListInfoDate>!
        filtrDate = jobDataList.filter("month = \(monthDay + 1)")
        return filtrDate
    }

    private func allTimeMonth(_ section: Results<ListInfoDate>) -> String {
        var allTime: Double = 0.0
        for timeDay in section {
            allTime = allTime + (valueSettingsOfLunchtime.first?.automaticLunch ?? true ? timeDay.fullTimeWork : timeDay.timeWorkWithLunch)
        }
        if allTime == 0.0 {
            return ""
        } else {
        return String(allTime)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDate", for: indexPath)
        cell.backgroundColor = UIColor.clear
                
        let dateFormatterDay = DateFormatter()
        dateFormatterDay.dateFormat = "dd / MM, EEEE"
        dateFormatterDay.locale = Locale(identifier: "RU_RU")
        
        let sortDate2 = arrayJobDataList[indexPath.section]
        let jobDataLists = sortDate2[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = dateFormatterDay.string(from: jobDataLists.dateWorkShift )
        content.textProperties.font = UIFont.init(name: "Zapf Dingbats", size: 18.0) ??
            .preferredFont(forTextStyle: .body)
        content.secondaryText = "Часы: \(valueSettingsOfLunchtime.first?.automaticLunch ?? true ? jobDataLists.fullTimeWork : jobDataLists.timeWorkWithLunch)"
        cell.contentConfiguration = content
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .init(red: 0.134, green: 0.128, blue: 0.128, alpha: 0.2)
        
        let header = view as! UITableViewHeaderFooterView
        var content = header.defaultContentConfiguration()
        content.prefersSideBySideTextAndSecondaryText = true

        
        let monthNameFals = arrayJobDataList[section]
        let monthNameTrue = monthNameFals.first?.month
        content.text = monthName[monthNameTrue ?? 5]
        content.secondaryText = allTimeMonth(monthNameFals)
        content.secondaryTextProperties.font = UIFont.init(name: "Zapf DingBats", size: 20.0)!
        content.secondaryTextProperties.color = .white
        content.textProperties.color = .white
        content.textProperties.font = UIFont.init(name: "Courier", size: 22.0) ?? .preferredFont(forTextStyle: .body)
        header.contentConfiguration = content
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {


         sortDate2 = arrayJobDataList[indexPath.section]
         jobDataLists = sortDate2[indexPath.row]



        let currentList = jobDataLists ?? jobDataList[indexPath.row] // нвыести порядок!!!
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.deleteListInfo(infoList: currentList)

            let value = self.sortDate2.count
            if value == 0 {
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)

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

                 sortDate2 = arrayJobDataList[indexPath.section]
                 jobDataLists = sortDate2[indexPath.row]

                    let info = jobDataLists
                    detailedVC.info = info
                   detailedVC.boolValueOfLunch = valueSettingsOfLunchtime.first?.automaticLunch
            }

            } else if segue.identifier == "settingsVC" {
                if let settingsVC = segue.destination as? SettingsViewController {
                    settingsVC.saveCompletionSettings = {
                        self.tableView.reloadData()

            }
                }
            else { return }
                
            }
    }
            
 
    override func viewWillAppear(_ animated: Bool) {
        readDataAndUpdateUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    private func readDataAndUpdateUI() {
        jobDataList = StorageManager.shared.realm.objects(ListInfoDate.self).sorted(byKeyPath: "dateWorkShift")
        
        self.setEditing(false, animated: true)
        self.tableView.reloadData()
    }
    
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
                                        self.arrayJobDataList.removeAll()
                                        self.readDataAndUpdateUI()
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
}
