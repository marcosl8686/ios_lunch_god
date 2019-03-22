//
//  AppDelegate.swift
//  Flash Chat
//
//  The App Delegate listens for events from the system. 
//  It recieves application level messages like did the app finish launching or did it terminate etc. 
//

import UIKit
import Firebase
import Moya
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()
    let locationService = LocationServices()
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpService.BusinessProvider>()
    let jsonDecoder = JSONDecoder()
    var calendarModel : [CalendarDB] = [CalendarDB]() {
        didSet{
            massCalendarUpdate()
        }
    }
    var eventCount = 0
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        //Initialise and Configure your Firebase here:
        FirebaseApp.configure()
        retrieveRestList()
        switch locationService.status {
        case .notDetermined, .denied, .restricted:
            let locationViewController = storyBoard.instantiateViewController(withIdentifier: "AccessViewController") as? AccessViewController
            window.rootViewController = locationViewController
            locationViewController?.locationService = locationService
            window.rootViewController = locationViewController
        default:
            let nav = storyBoard.instantiateViewController(withIdentifier: "navBar1") as? UINavigationController
            window.rootViewController = nav
            loadBusiness()
        }
        window.makeKeyAndVisible()
        return true
    }

    private func loadBusiness() {
        print("Loaded")
    }
    
    func retrieveRestList() {
        let calendarFB = Database.database().reference().child("calendarDates")
        calendarFB.observe(.value) { (snapshot) in
            self.eventCount = Int(snapshot.childrenCount)
            calendarFB.observe(.childAdded) { (snapshot) in
                let snapshotValue =  snapshot.value as! Dictionary<String, String>
                let restName = snapshotValue["title"] ?? "n/a"
                let imageUrl = snapshotValue["imageUrl"] ?? "n/a"
                let user = snapshotValue["user"] ?? "n/a"
                let restaurantId = snapshotValue["id"] ?? "n/a"
                let date = snapshotValue["startDate"] ?? "n/a"
                let scheduledDates = CalendarDB()
                scheduledDates.id = restaurantId
                scheduledDates.title = restName
                scheduledDates.startDate = date
                scheduledDates.imageUrl = imageUrl
                scheduledDates.userEmail = user
                self.calendarModel.append(scheduledDates)
            }
        }
        
    }
    
    func massCalendarUpdate() {
        if calendarModel.count == eventCount {
            for calendarItem in calendarModel {
                var appendEvent = true
                let eventStore: EKEventStore = EKEventStore()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateConverted = dateFormatter.date(from: calendarItem.startDate)
                let calendars = eventStore.calendars(for: .event)
                for calendar in calendars {
                    if calendar.title == "Calendar" {
                        let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                        let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)
                        let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])
                        let events = eventStore.events(matching: predicate)
                        for event in events {
                            if event.title! == "Lunch at: \(calendarItem.title) - user: \(calendarItem.userEmail)" && event.startDate! == dateConverted! {
                                appendEvent = false
                            }
                        }
                        if appendEvent {
                            eventStore.requestAccess(to: .event) { (granted, error) in
                                if (granted) && (error == nil) {
                                    let event: EKEvent = EKEvent(eventStore: eventStore)
                                    event.title = "Lunch at: \(calendarItem.title) - user: \(calendarItem.userEmail)"
                                    event.startDate = dateConverted
                                    event.endDate = dateConverted
                                    event.notes = "\(calendarItem.userEmail) Picked this Restaurant"
                                    event.calendar = eventStore.defaultCalendarForNewEvents
                                    let alarm1hour = EKAlarm(relativeOffset: -3600)
                                    event.addAlarm(alarm1hour)

                                    do {
                                        try eventStore.save(event, span: .thisEvent)

                                    } catch let error as NSError {
                                        print("Error: \(error)")
                                    }

                                } else {
                                    print("Error!: \(error!)")
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    
    
}

