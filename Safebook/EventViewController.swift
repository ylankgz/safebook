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

class EventViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var calendar: FSCalendar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.dataSource = self
        calendar.delegate = self
        
    }

    
    @IBAction func addEventTapped(_ sender: Any) {
        let eventStore:EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                event.title = "Add event testing"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "This is note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("error is \(error)")
                }
                print("Save event")
            } else {
                print("error is \(String(describing: error))")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.isStatusBarHidden = false
    }

}

