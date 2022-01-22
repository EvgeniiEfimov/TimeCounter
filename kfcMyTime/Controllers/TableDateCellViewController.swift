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
    var sortDate: Results<ListInfoDate>!
    
    private var jobDataList: Results<ListInfoDate>!
    private var monthName = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь","Июль",  "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    private let calendar = Calendar.current
    
//    private func monthValue (_ monthArray: [String]) -> String {
//        for month in monthArray {
//            return month
//        }
//    }

        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "backTableImage1"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.alpha = 0.1
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        monthName.count
        var count = 0
        for month in 0...monthName.count {
           countRows = sortDataToMonth(month)
            if countRows.count != 0 {
                count += 1
            }
        }
        return count - 1
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//         2
//    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        monthName[section] + "   " + allTimeMonth(section)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        countRows = sortDataToMonth(section)
        return countRows?.count ?? 0
    }

    private func sortDataToMonth(_ section: Int) -> Results<ListInfoDate>! {
        var filtrDate: Results<ListInfoDate>!
//        var timeMoncth: Double
        switch section {
        case 0:
            filtrDate = jobDataList.filter("month = 1")
            return filtrDate
        case 1:
            filtrDate = jobDataList.filter("month = 2")
            return filtrDate
        case 2:
            filtrDate = jobDataList.filter("month = 3")
            return filtrDate
        case 3:
            filtrDate = jobDataList.filter("month = 4")
            return filtrDate
        case 4:
            filtrDate = jobDataList.filter("month = 5")
            return filtrDate
        case 5:
            filtrDate = jobDataList.filter("month = 6")
            return filtrDate
        case 6:
            filtrDate = jobDataList.filter("month = 7")
            return filtrDate
        case 7:
            filtrDate = jobDataList.filter("month = 8")
            return filtrDate
        case 8:
            filtrDate = jobDataList.filter("month = 9")
            return filtrDate
        case 9:
            filtrDate = jobDataList.filter("month = 10")
            return filtrDate
        case 10:
            filtrDate = jobDataList.filter("month = 11")
            return filtrDate
        case 11:
            filtrDate = jobDataList.filter("month = 12")
            return filtrDate
        default:
            return jobDataList
        }
    }
    
    private func allTimeMonth(_ section: Int) -> String {
        let dayInSection = sortDataToMonth(section)
        var allTime: Double = 0.0
        for timeDay in dayInSection! {
            allTime = allTime + timeDay.timeWork
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
        
    
//        jobDataLists = jobDataList[indexPath.row]
        
        sortDate = sortDataToMonth(indexPath.section)
        jobDataLists = sortDate![indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = dateFormatterDay.string(from: jobDataLists.dateWorkShift)
        content.secondaryText = "Часы: \(jobDataLists.timeWork)"
        cell.contentConfiguration = content
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        sortDate = sortDataToMonth(indexPath.section)
//        jobDataLists = sortDate[indexPath.row]
//    }
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .init(red: 0.134, green: 0.128, blue: 0.128, alpha: 0.2)
//        view.backgroundColor = .brown
        
        let header = view as! UITableViewHeaderFooterView
//        header.textLabel?.textColor = .white
//        header.textLabel?.font = UIFont.init(name: "Courier", size: 22.0)
//        header.textLabel?.textAlignment = .right
//        header.automaticallyUpdatesContentConfiguration = true
        var content = header.defaultContentConfiguration()
        
//        content.textToSecondaryTextHorizontalPadding = 0.0
//        content.textToSecondaryTextVerticalPadding = 0.0
//        content.secondaryTextProperties.font = UIFont.init(name: "Courier", size: 22.0)!
//        content.secondaryTextProperties.alignment = .center
//        content.textProperties.alignment = .justified
//        content.secondaryText = allTimeMonth(section)
//        print(content.secondaryText)
        content.prefersSideBySideTextAndSecondaryText = true
        content.text = monthName[section]
        content.secondaryText = allTimeMonth(section)
        content.secondaryTextProperties.font = UIFont.init(name: "Zapf DingBats", size: 20.0)!
        content.secondaryTextProperties.color = .white
        content.textProperties.color = .white
        content.textProperties.font = UIFont.init(name: "Courier", size: 22.0)!
        header.contentConfiguration = content
        
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        sortDate = sortDataToMonth(indexPath.section)
        jobDataLists = sortDate[indexPath.row]

        
        let currentList = jobDataLists ?? jobDataList[indexPath.row] // нвыести порядок!!!
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            StorageManager.shared.delete(infoList: currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
        }
//        tableView.endUpdates()
//        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)

        return UISwipeActionsConfiguration(actions: [deleteAction])

    }
    
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
                    sortDate = sortDataToMonth(indexPath.section)
                    jobDataLists = sortDate[indexPath.row]
                    let info = jobDataLists


                    detailedVC.info = info
            }
                
            } else { return }
        
//        if let addJobDateVC = segue.destination as? AddJobDateViewController {
//            addJobDateVC.saveCompletion = {
//                self.tableView.reloadData()
//            }} else if let detailedVC = segue.destination as? DetailedInformationViewController {
//                guard let indexPath = tableView.indexPathForSelectedRow else {
//                    return
//                }
//                sortDate = sortDataToMonth(indexPath.section)
//                jobDataLists = sortDate[indexPath.row]
//                let info = jobDataLists
//
//
//                detailedVC.info = info
//            } else {
//                return
//            }
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
                                        StorageManager.shared.deleteAll()
                                        self.readDataAndUpdateUI()
                                    }))
        alertDelete.addAction(.init(title: "Нет",
                                    style: .default,
                                    handler: nil))
        
        present(alertDelete,
                animated: true,
                completion: nil)
    }
}
