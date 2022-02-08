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
//        Results<ListInfoDate>!
    
    
    lazy var arrayMonchFiltr = [Results<ListInfoDate>]()
    var arrayMonthFiltr2 = [Int : [ListInfoDate]]()
    
    private var jobDataList: Results<ListInfoDate>!
    
    private var arrayJobDataList = [Results<ListInfoDate>]()
    
    private let monthName = DataManager.shared.monthArray
//        ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь","Июль",  "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"]
    private let calendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.backgroundView = UIImageView(image: UIImage(named: "backTableImage1"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.alpha = 0.1
        
        }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        sortDataToMonth2()
        print(arrayJobDataList)
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
                    print(!arrayJobDataList.contains(filtrDate))
            arrayJobDataList.append(filtrDate)
                }
            }
        }
    }
//    
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        var count = 0
//        for month in 0...monthName.count {
//           countRows = sortDataToMonth(month)
//            if countRows.count != 0 {
//                count += 1
//            }
//        }
//        return count - 1
//    }
    
    
    private func sortDataToMonth(_ monthDay: Int) -> Results<ListInfoDate>! {
        var filtrDate: Results<ListInfoDate>!
        switch monthDay {
        case 0:
            filtrDate = jobDataList.filter("month = 1")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 1:
            filtrDate = jobDataList.filter("month = 2")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 2:
            filtrDate = jobDataList.filter("month = 3")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 3:
            filtrDate = jobDataList.filter("month = 4")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 4:
            filtrDate = jobDataList.filter("month = 5")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 5:
            filtrDate = jobDataList.filter("month = 6")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 6:
            filtrDate = jobDataList.filter("month = 7")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 7:
            filtrDate = jobDataList.filter("month = 8")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 8:
            filtrDate = jobDataList.filter("month = 9")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 9:
            filtrDate = jobDataList.filter("month = 10")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 10:
            filtrDate = jobDataList.filter("month = 11")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        case 11:
            filtrDate = jobDataList.filter("month = 12")
//            arrayJobDataList.append(filtrDate)
            return filtrDate
        default:
            return jobDataList
        }
    }
   
    
    
//    private func sortDataToMonth(_ data: Results<ListInfoDate>) -> [Results<ListInfoDate>] {
//        var filtrDate: Results<ListInfoDate>
//        var arrayFiltrDate = [Results<ListInfoDate>]()
//        for month in data {
//            switch month.month {
//        case 0:
//            filtrDate = jobDataList.filter("month = 1")
//            arrayFiltrDate.append(filtrDate)
//        case 1:
//            filtrDate = jobDataList.filter("month = 2")
//            arrayFiltrDate.append(filtrDate)
//        case 2:
//            filtrDate = jobDataList.filter("month = 3")
//            arrayFiltrDate.append(filtrDate)
//        case 3:
//            filtrDate = jobDataList.filter("month = 4")
//            arrayFiltrDate.append(filtrDate)
//        case 4:
//            filtrDate = jobDataList.filter("month = 5")
//            arrayFiltrDate.append(filtrDate)
//        case 5:
//            filtrDate = jobDataList.filter("month = 6")
//            arrayFiltrDate.append(filtrDate)
//        case 6:
//            filtrDate = jobDataList.filter("month = 7")
//            arrayFiltrDate.append(filtrDate)
//        case 7:
//            filtrDate = jobDataList.filter("month = 8")
//            arrayFiltrDate.append(filtrDate)
//        case 8:
//            filtrDate = jobDataList.filter("month = 9")
//            arrayFiltrDate.append(filtrDate)
//        case 9:
//            filtrDate = jobDataList.filter("month = 10")
//            arrayFiltrDate.append(filtrDate)
//        case 10:
//            filtrDate = jobDataList.filter("month = 11")
//            arrayFiltrDate.append(filtrDate)
//        case 11:
//            filtrDate = jobDataList.filter("month = 12")
//            arrayFiltrDate.append(filtrDate)
//        default:
//            return []
//        }
//    }
//    }
    private func allTimeMonth(_ section: Results<ListInfoDate> ) -> String {
//        let dayInSection = sortDataToMonth(section)
        var allTime: Double = 0.0
        for timeDay in section {
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
        
        let sortDate2 = arrayJobDataList[indexPath.section]
        let jobDataLists = sortDate2[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = dateFormatterDay.string(from: jobDataLists.dateWorkShift )
        content.textProperties.font = UIFont.init(name: "Zapf Dingbats", size: 18.0) ??
            .preferredFont(forTextStyle: .body)
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

        
        let monthNameFals = arrayJobDataList[section]
        let monthNameTrue = monthNameFals.first?.month
        content.text = monthName[monthNameTrue ?? 5]
            //            monthName[section]
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
            StorageManager.shared.delete(infoList: currentList)

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
            }

            } else {
                return

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
                                        StorageManager.shared.deleteAll()
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
}
