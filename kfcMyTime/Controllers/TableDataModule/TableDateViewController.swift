//
//  TableViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import RealmSwift
import SPAlert
import Spring

protocol TableDataViewControllerProtocol: AnyObject {
    func setView(with data: Results<ListInfoOfMonch>?)
    func setSetting(with setting: Results<SettingRateAndFormatDate>?)
    func tableViewDeleteSection(_ indexPath: IndexPath)
    func tableViewDeleteRow(_ indexPath: IndexPath)
    func showSpAlert(_ text: String)
}

class TableDateViewController: UITableViewController {
    
    var presenter: TableDataPresenterProtocol!
    let configurator: TableDataConfiguratorProtocol = TableDataConfigurator()
    
    let selfToAddSegueName = "addVC"
    
    //MARK: - Outlet
    /// outlet кнопки добавления
    @IBOutlet weak var addButton: UIBarButtonItem!
    //MARK: - Приватные свойства
    /// Объявление переменной хранящей данные realm по месяцам
    private var listInfoOfMonch: Results<ListInfoOfMonch>!
    /// Объявление переменной хранящей данные настроек
    private var settingsUser: Results<SettingRateAndFormatDate>!
    //MARK: - Методы переопределения
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
        ///Вызов метода настройки внешнего вида View
        startSettingOfBackgroundView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableView.scrollToBottom()
            self.animationCell()
        }
    }


    // MARK: - Table view data source
    /// Количество секции в таблице определяется количеством месяцев в БД
    override func numberOfSections(in tableView: UITableView) -> Int {
        listInfoOfMonch.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Swift"
    }
    
    /// Количество строк в секции
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /// Свойство определённое конкретным месяцем
        let day = listInfoOfMonch[section]
        /// Количество дней в месяце
        return day.monch.count
    }
    
    /// Переопределение ячеек таблицы
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// Определение ячцейки
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellDate", for: indexPath)
        cell.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
        ///  Настройка accessry
        let image = UIImage(systemName: "chevron.right")
        let accessory  = UIImageView(frame:CGRect(x:0, y:0, width:(image?.size.width)!, height:(image?.size.height)!))
        accessory.image = image
        accessory.tintColor = UIColor.systemYellow
        cell.accessoryView = accessory
     
        /// Определения данных по месяцу
        let monch = listInfoOfMonch[indexPath.section]
        /// Сортировка массива дней месяца
        let daySorted = monch.monch.sorted(byKeyPath: "dateWorkShift")
        /// Определение дня
        let day = daySorted[indexPath.row]
        /// Настройки ячейки. Определение.
        var content = cell.defaultContentConfiguration()
        /// Присваивание значения текста ячейки. Поле текст определо днём массива месяца
        content.text = dateFormatterDay(day.dateWorkShift)
        /// Определение цвета текста ячейки
        content.textProperties.color = .systemYellow
        /// Определение шрифта и размера текста ячейки
        content.textProperties.font = UIFont.init(name: "Zapf Dingbats", size: 18.0) ??
            .preferredFont(forTextStyle: .body)
        /// Определение дополнительного текста ячейки
        content.secondaryText = settingsUser.first?.formatSegmentControl == 1 ? String(format: "%.1f ч", day.timeWork) : day.timeWorkStringFormat
        /// Определение цвета дополнительного текста ячейки
        content.secondaryTextProperties.color = .systemYellow
        /// Присваивание конфигурации ячейки
        cell.contentConfiguration = content
        /// Возврат ячейки
        return cell
    }
    
/// Конфигурация header секции
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        /// Цвет header ячейки
        view.tintColor = .systemYellow
        /// Прозрачность header
        view.alpha = 0.9
/// Приведение  view к UITableViewHeaderFooterView
        let header = view as! UITableViewHeaderFooterView
        /// Присвоение переменной дефолтных конфигураций
        var content = header.defaultContentConfiguration()
        /// Расположение основного и дополнительного текста  секции
        content.prefersSideBySideTextAndSecondaryText = true
        /// Определение месяца согласно номеру секции
        let month = listInfoOfMonch[section]
        /// Присвоение значения текста секции
        content.text = month.nameMonth
        /// Присвоения значени дополнительного текста секции
        content.secondaryText = settingsUser.first?.formatSegmentControl == 1 ? String(format: "%.1f ч", month.allWorkTimeOfMonch) : timeWorkOfFormatString(month.allWorkTimeOfMonch)
        /// Определения шрифта и размера дополнительного текста
        content.secondaryTextProperties.font = UIFont.init(name: "Zapf DingBats", size: 20.0)!
        /// Определение цвета дополнительного текста
        content.secondaryTextProperties.color = .darkGray
        /// Определения цвета текста секции
        content.textProperties.color = .darkGray
        /// Определения шрифта и размера  текста
        content.textProperties.font = UIFont.init(name: "Courier", size: 22.0) ?? .preferredFont(forTextStyle: .body)
        /// Присвоения конфигурации header
        header.contentConfiguration = content
    }
    
    /// Переопределения метода свайпа
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.presenter.swipeCellLeft(indexPath)
        }
        /// Присвоение конфигурации свайпа
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    /// Переопределения метода  перехода между vc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Проверка идентификатора контроллера перехода
         if segue.identifier == "addVC" {
            /// Проверка приведения seque к требуемуему VC
            if let addJobDateVC = segue.destination as? AddJobDateViewController {
                /// Комплишн
                addJobDateVC.saveCompletion = {
                    /// Вызов метода обновления данных таблицы
                        self.tableView.scrollToBottom()
                        self.animationCell()
                }
                /// Проверка идентификатора seque
            }
        } else if segue.identifier == "detailVC" {
            /// Проверка приведения seque к требуемуему VC
            if let detailedVC = segue.destination as? DetailedInformationViewController {
                /// Определение свойства indexPath как номер строки таблицы
                guard let indexPath = tableView.indexPathForSelectedRow else {
                    return
                }
                detailedVC.indexPathSection = indexPath.section
                detailedVC.indexPathRow = indexPath.row
            }
        }
    }
            
//MARK: - Action

    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        presenter.addButtonAction()
    }
    
//MARK: - Приватные методы
    /// Метод настройки внешнего вида View
    private func startSettingOfBackgroundView() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "269"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.alpha = 0.6
        tableView.backgroundColor = UIColor.gray
    }

    private func animationCell() {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let height = 0 - tableView.bounds.width
        var delay: Double = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: height, y: height)
            
            UIView.animate(withDuration: 0.2,
                           delay: delay * 0.02,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: { cell.transform = CGAffineTransform.identity})
            delay += 1
        }
    }
}

extension TableDateViewController: TableDataViewControllerProtocol {
   
    func setSetting(with setting: Results<SettingRateAndFormatDate>?) {
        guard let setting = setting else {
            dismiss(animated: true)
            return
        }
        settingsUser = setting
    }
    
    func setView(with data: Results<ListInfoOfMonch>?) {
        guard let info = data else {
            dismiss(animated: true)
            return
        }
        listInfoOfMonch = info
    }
    
    func tableViewDeleteSection(_ indexPath: IndexPath) {
        tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func tableViewDeleteRow(_ indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
    }
    
    func showSpAlert(_ text: String) {
        let alertView = SPAlertView(title: text, preset: .error)
        alertView.duration = 1.3
        alertView.cornerRadius = 12
        alertView.backgroundColor = UIColor.darkGray
        alertView.present()
    }
}


