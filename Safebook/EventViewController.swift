//
//  EventViewController.swift
//  Safebook
//
//  Created by Ulan on 11/12/17.
//  Copyright © 2017 SafebookApp. All rights reserved.
//

import UIKit
import EventKit
import FSCalendar

class EventViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    @IBOutlet weak var pickerView: UIPickerView!
    var eventTitle:String = "СУД ПЕРВОЙ ИНСТАНЦИИ"
    var deadLine:Date = Date()
    var pickerData: [String] = [String]()
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerData = ["СУД ПЕРВОЙ ИНСТАНЦИИ", "РЕШЕНИЕ", "ПРОТОКОЛ", "АППЕЛЯЦИЯ", "КАССАЦИЯ", "ДОСУДЕБНОЕ ПРОИЗВОДСТВО"]
        
        calendar.dataSource = self
        calendar.delegate = self
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
    }

    
    @IBAction func addEventTapped(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.eventTitle
                let alarm:EKAlarm = EKAlarm(relativeOffset: -600)
                event.alarms = [alarm]
                
                switch (self.eventTitle) {
                case "СУД ПЕРВОЙ ИНСТАНЦИИ":
                    event.startDate = Date(timeInterval: 89*86400+43200, since: self.deadLine)
                    event.endDate = Date(timeInterval: 89*86400+46800, since: self.deadLine)
                    event.notes = "Ваше гражданское дело рассматривается и должно разрешиться завтра."
                case "РЕШЕНИЕ":
                    event.startDate = Date(timeInterval: 4*86400+43200, since: self.deadLine)
                    event.endDate = Date(timeInterval: 4*86400+46800, since: self.deadLine)
                    event.notes = "Не забудьте забрать решение суда. Должно быть готово не позднее чем завтра"
                case "ПРОТОКОЛ":
                    event.startDate = Date(timeInterval: 2*86400+43200, since: self.deadLine)
                    event.endDate = Date(timeInterval: 2*86400+46800, since: self.deadLine)
                    event.notes = "Протокол должен быть составлен и подписан не позднее чем завтра"
                case "АППЕЛЯЦИЯ":
                    event.startDate = Date(timeInterval: 29*86400+43200, since: self.deadLine)
                    event.endDate = Date(timeInterval: 29*86400+46800, since: self.deadLine)
                    event.notes = "Апелляционная жалоба (представление) на решение суда может быть подана не позднее чем завтра"
                case "КАССАЦИЯ":
                    event.startDate = Date(timeInterval: 89*86400+43200, since: self.deadLine)
                    event.endDate = Date(timeInterval: 89*86400+46800, since: self.deadLine)
                    event.notes = "Кассационная жалоба (представление) может быть подана не позднее чем завтра"
                case "ДОСУДЕБНОЕ ПРОИЗВОДСТВО":
                    event.startDate = Date(timeInterval: 59*86400+43200, since: self.deadLine)
                    event.endDate = Date(timeInterval: 59*86400+46800, since: self.deadLine)
                    event.notes = "Досудебное производство по уголовным делам должно быть закончено в срок не позднее чем завтра"
                default:
                    ()
                }
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    self.displayAlert(title: "Error".localize, message: String(describing: error))
                }
                self.displayAlert(title: "Success".localize, message: "Event created!".localize)
            } else {
                self.displayAlert(title: "Error".localize, message: String(describing: error))
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok".localize, style: .cancel)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        eventTitle = pickerData[row]
        print(eventTitle)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.deadLine = date
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
        self.deadLine = date
    }
    
    
    @IBAction func doneTapped(_ sender: Any) {
        navigationController?.dismiss(animated: true, completion: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppUtility.lockOrientation(.portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
    }
}

