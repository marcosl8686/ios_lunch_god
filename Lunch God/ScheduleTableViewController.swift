//
//  ScheduleTableViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 3/21/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import Moya

class ScheduleTableViewController: UITableViewController {

    var calendarModel : [CalendarDB] = [CalendarDB]() {
        didSet{
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "scheduledRestaurant", bundle: nil), forCellReuseIdentifier: "scheduleCustomCell")
        tableView.separatorStyle = .none
        retrieveRestList()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarModel.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "scheduleCustomCell", for: indexPath) as! ScheduleCell
        let vm = calendarModel[indexPath.row]
        let imageUrlLink = URL(string: vm.imageUrl)
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = formatter.date(from:vm.startDate)!
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "EEEE d"
        let displayDate = newFormatter.string(from: date)
        
        cell.scheduleRestName.text = vm.name
        cell.scheduleRestImage.af_setImage(withURL: imageUrlLink!)
        cell.scheduleDate.text = displayDate
        return cell
    }

    
    
    func retrieveRestList() {
        let calendarFB = Database.database().reference().child("calendarDates")
        calendarFB.observe(.value) { (snapshot) in
            calendarFB.observe(.childAdded) { (snapshot) in
                let snapshotValue =  snapshot.value as! Dictionary<String, String>
                let restName = snapshotValue["title"] ?? "n/a"
                let imageUrl = snapshotValue["imageUrl"] ?? "n/a"
                let user = snapshotValue["user"] ?? "n/a"
                let restaurantId = snapshotValue["id"] ?? "n/a"
                let date = snapshotValue["startDate"] ?? "n/a"
                let name = snapshotValue["name"] ?? "n/a"
                let scheduledDates = CalendarDB()
                scheduledDates.id = restaurantId
                scheduledDates.title = restName
                scheduledDates.startDate = date
                scheduledDates.imageUrl = imageUrl
                scheduledDates.userEmail = user
                scheduledDates.name = name
                self.calendarModel.append(scheduledDates)
            }
        }
        
    }
    
}
