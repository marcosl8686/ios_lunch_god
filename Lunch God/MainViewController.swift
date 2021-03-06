//
//  MainViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/21/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import EventKit
import Moya
import SwiftyJSON
import MapKit
import CoreLocation
import Firebase

class MainViewController: UIViewController {
    @IBOutlet weak var detailsFoodView: DetailsFoodView?
    @IBOutlet weak var datePickerTextField: UITextField!
    let service = MoyaProvider<YelpService.BusinessProvider>()
    let jsonDecoder = JSONDecoder()
    let toolbar = UIToolbar()
    var comingFromSearch: Bool = false
    
    var selectedRestaurant: RestaurantListViewModel? {
        didSet {
            print("SELECTEDRESTAURANT SET!")
            if let restaurantId = selectedRestaurant {
                comingFromSearch = true
                loadDetails(width: restaurantId.id)
            }
        }
    }
    var selectedRestaurantMyList: MyListDB? {
        didSet {
            print("SELECTEDRESTAURANT SET!")
            if let restaurantId = selectedRestaurantMyList {
                loadDetails(width: restaurantId.id)
            }
        }
    }
    var viewModels: DetailsViewModel? {
        didSet{
            print("SET!123")
        }
    }
    var selectedDate = Date()
    
    private var datePicker: UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        datePicker = UIDatePicker()
        datePicker?.addTarget(self, action: #selector(MainViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        datePickerTextField.inputView = datePicker
        detailsFoodView?.collectionView?.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        detailsFoodView?.collectionView?.delegate = self
        detailsFoodView?.collectionView?.dataSource = self
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        toolbar.setItems([doneButton], animated: true)
        datePickerTextField.inputAccessoryView = toolbar
        
    }
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged (datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        datePickerTextField.text = dateFormatter.string(from: datePicker.date)
        print("Date format from the Picker = \(datePicker.date)")
        selectedDate = datePicker.date
    }
    
    @objc func doneClicked() {
        view.endEditing(true)
    }
    
    @IBAction func addEventBtn(_ sender: Any) {
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title =   "Lunch at: \(String(describing: self.viewModels!.name)) - user: \(String(Auth.auth().currentUser!.email!))"
                event.startDate = self.selectedDate
                event.endDate = self.selectedDate
                event.notes = "\(Auth.auth().currentUser!.email!) Picked this Restaurant"
                event.calendar = eventStore.defaultCalendarForNewEvents
                let alarm1hour = EKAlarm(relativeOffset: -3600)
                event.addAlarm(alarm1hour)
                
                let formatter = DateFormatter()
                // initially set the format based on your datepicker date / server String
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let myDateString = formatter.string(from: self.selectedDate)
                let myCalendarDB = Database.database().reference().child("calendarDates")
                let restaurantName: String! = self.viewModels?.name ?? self.selectedRestaurantMyList?.restaurantName
                let restaurantImageUrl = self.selectedRestaurant?.imageUrl == nil ? nil : String(describing: self.selectedRestaurant!.imageUrl)
                let myCalendarDictionary = ["user": Auth.auth().currentUser!.email, "title": "Lunch at: \(String(describing: restaurantName!)) - user: \(String(Auth.auth().currentUser!.email!))", "startDate": myDateString, "id": self.selectedRestaurant?.id ?? self.selectedRestaurantMyList?.id, "imageUrl": restaurantImageUrl ?? self.selectedRestaurantMyList!.imageURL, "name": restaurantName]
                
                myCalendarDB.childByAutoId().setValue(myCalendarDictionary) {
                    (error, reference) in
                    if error != nil {
                        print(error!)
                    } else {
                        print("Message saved Successfully")
                    }
                }
                do {
                    try eventStore.save(event, span: .thisEvent)
                    //Alert Event has been added
                    let alert = UIAlertController(title: "Event Added Successfully", message: "Your Restaurant '\(restaurantName ?? "N/A")' has been scheduled on '\(myDateString)'", preferredStyle:.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }))
                    //show Alert
                    
                    self.present(alert, animated: true, completion: nil)
                    
                } catch let error as NSError {
                    print("Error: \(error)")
                }
                if self.comingFromSearch {
                    //Add To FireBase
                    let myRestListDB = Database.database().reference().child(Auth.auth().currentUser!.uid)
                    let myRestListeDictionary = ["user": Auth.auth().currentUser!.email, "id" : self.selectedRestaurant!.id, "name": self.selectedRestaurant!.name, "imageUrl": "\(self.selectedRestaurant!.imageUrl)", "distance": self.selectedRestaurant!.distance, "price": self.selectedRestaurant!.price, "address": self.selectedRestaurant?.location, "type": self.selectedRestaurant?.categories]
                    
                    myRestListDB.childByAutoId().setValue(myRestListeDictionary) {
                        (error, reference) in
                        if error != nil {
                            print(error!)
                        } else {
                            print("Message saved Successfully")
                        }
                    }
                }
                
            } else {
                print("Error!: \(error!)")
            }
        }
        
    }
    
    
    private func loadDetails(width id: String) {
        service.request(.details(id: id)) { (result) in
            switch result {
            case .success(let response):
                if let details = try? self.jsonDecoder.decode(Details.self, from: response.data) {
                    self.detailsFoodView?.priceLabel?.text = details.price
                    self.detailsFoodView?.hoursLabel?.text = details.isClosed ? "Closed": "Open"
                    self.detailsFoodView?.locationLabel?.text = details.phone
                    self.detailsFoodView?.ratingLabel?.text = "\(details.rating) / 5.0"
                    self.parent?.title = details.name
                    let detailsViewModel = DetailsViewModel(details: details)
                    self.viewModels = detailsViewModel
                    self.centerMap(for: details.coordinates)
                    self.detailsFoodView?.collectionView?.reloadData()
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailsFoodView?.mapView?.addAnnotation(annotation)
        detailsFoodView?.mapView?.setRegion(region, animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels?.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! DetailsCollectionViewCell
        if let url = viewModels?.imageUrls[indexPath.item] {
            cell.imageView.af_setImage(withURL: url)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        detailsFoodView?.pageControl?.currentPage = indexPath.item
    }
}

