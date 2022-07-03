//
//  TableViewController.swift
//  kfcMyTime
//
//  Created by User on 26.10.2021.
//

import RealmSwift
import SPAlert
import Spring

class TableDateCellViewController: UITableViewController {
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
        ///Вызов метода настройки внешнего вида View
        startSettingOfBackgroundView()
        /// Присвоение переменной хранящей данные realm по месяцам
        listInfoOfMonch = StorageManager.shared.realm.objects(ListInfoOfMonch.self).sorted(byKeyPath: "numberMonth")
        settingsUser = StorageManager.shared.realm.objects(SettingRateAndFormatDate.self)
        ///Проверка на наличие данных в realm
        if listInfoOfMonch.isEmpty {
            ///Вызов алерта-инструкции при первом запуске
            alertFirstStart()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///Обновление данных таблицы
        tableView.reloadData()
        
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
        /// Определение свойства месяца, соответствующего номеру секции
        let monch = listInfoOfMonch[indexPath.section]
        /// Сортировка массива дней месяца
        let daySorted = monch.monch.sorted(byKeyPath: "dateWorkShift")
        /// Присвоения свойству дня, соответствующего номеру строки таблицы
        let day = daySorted[indexPath.row]
        ///  Определения действия при свайпе
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            /// Удаление дня из БД
            StorageManager.shared.deleteMonch(monch: day, in: monch)
            /// Проверка количества дней в месяце секции
            if monch.monch.count == 0 {
                /// Удаление месяца (Если нет записанных дней)
                StorageManager.shared.deleteMonch(allMonch: monch)
                /// Удаление секции "пустого" (удаленного) месяца
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                /// Вызов визуального эффекта (подтверждения) удаления
                self.spAlert()
            } else {
                /// Удаление ячейки удаленного дня
                tableView.deleteRows(at: [indexPath], with: .automatic)
                /// Обновление секции
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                /// Вызов визуального эффекта (подтверждения) удаления
                self.spAlert()
            }
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
                    self.tableView.reloadData()
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
                /// Определение свойства месяца, соответствующего номеру секции
                let month = listInfoOfMonch[indexPath.section]
                /// Сортировка массива дней месяца
                let sortDay = month.monch.sorted(byKeyPath: "dateWorkShift")
                /// Определение свойства дня, соответствующего номеру строки
                let day = sortDay[indexPath.row]
                /// Определение свойства информации  дня
                let infoOfDay = day.day
                /// Присвоение свойству Info (detailedVC) информаци рабочего дня
                detailedVC.info = infoOfDay
            }
        }
    }
            
    /// Переопределения метода
    override func viewDidAppear(_ animated: Bool) {
        /// Обновление табличных данных
        tableView.reloadData()
    }

//MARK: - Action

    
//MARK: - Приватные методы
    /// Метод настройки внешнего вида View
    private func startSettingOfBackgroundView() {
        tableView.backgroundView = UIImageView(image: UIImage(named: "269"))
        tableView.backgroundView?.contentMode = .scaleAspectFill
        tableView.backgroundView?.alpha = 0.6
        tableView.backgroundColor = UIColor.gray
    }
    /// Инициализация алерта первого запуска
    private func alertFirstStart() {
        let alertStart = UIAlertController(title: "Привет!",
                                           message: """
Краткая инструкция:
* Для добавления смены воспользуйтесь иконкой ➕ в правом верхнем углу
* Для удаления определенной смены воспользуйтесь свайпом  👈🏻 влево на необходимой ячейки
* Иконка корзины 🗑 в левом верхнем углу служит для удаления всех смен (без возможности возврата!)
* ⚙️ позволит настроить учет обеденного перерыва, часовую ставку а так же уведомления
* ВНИМАНИЕ! Данное приложение носит исключительно информативный характер и предназначено для
более удобного отслеживания рабочих часов. Все расчеты являются приблизительными
""",
                                           preferredStyle: .alert)
        /// Добавление кнопки в алерт
        alertStart.addAction(.init(title: "Понятно!",
                                   style: .default,
                                   handler: nil))
        /// Представление алерта
        present(alertStart, animated: true, completion: nil)
    }
    /// Метод вызова алерта визуального подтверждения удаления
    private func spAlert() {
        let alertView = SPAlertView(title: "Удалено", preset: .error)
        alertView.duration = 1.3
        alertView.cornerRadius = 12
        alertView.backgroundColor = UIColor.darkGray
        alertView.present()
    }
}
///  Расширение класса
extension TableDateCellViewController {
    /// Метод форматирования представления даты рабочей смены
    func dateFormatterDay (_ dateDay: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd / MM, EEE"
        dateFormatter.locale = Locale(identifier: "Ru_Ru")
        return dateFormatter.string(from: dateDay)
    }
//        /// Метод подсчета общего количества рабочих часов за месяц
//    func allTimeMonch(_ monch: ListInfoOfMonch) -> Double {
//        var allTimeMonch = 0.0
//        for timeDay in monch.monch {
//            allTimeMonch += timeDay.timeWork
//        }
//        return allTimeMonch
//    }
    /// Форматирование рабочего времени в формат Часы - минуты
    func timeWorkOfFormatString(_ timeInterval: Double) -> String {
    let formatter = DateComponentsFormatter()
        formatter.calendar?.locale = Locale(identifier: "Ru-ru")
    formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: TimeInterval(timeInterval * 3600.0))
        return formattedString ?? "-"
    }
    
}


