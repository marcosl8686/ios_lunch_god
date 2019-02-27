//
//  MainViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/21/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import EventKit

class MainViewController: UIViewController {
    @IBOutlet weak var detailsFoodView: DetailsFoodView!
    @IBOutlet weak var datePickerTextField: UITextField!
    
    
    
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(MainViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        datePickerTextField.inputView = datePicker
        
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    
    @objc func dateChanged (datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePickerTextField.text = dateFormatter.string(from: datePicker.date)
        print("Date format from the Picker = \(datePicker.date)")
        view.endEditing(true)
    }
    
    @IBAction func addEventBtn(_ sender: Any) {
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                print("granted \(granted)")
                print("error \(error!)")
                
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = "Add Event Title"
                event.startDate = Date()
                event.endDate = Date()
                event.notes = "Test Note"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("Error: \(error)")
                }
                print("Save Event Working. \(Date())")
                
            } else {
                print("Error!: \(error!)")
            }
        }
        
    }
    
}
