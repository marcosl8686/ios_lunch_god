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
    
    var selectedRestaurant: RestaurantListViewModel? {
        didSet {
            print("SELECTEDRESTAURANT SET!")
            if let restaurantId = selectedRestaurant {
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
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(MainViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewController.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
        datePickerTextField.inputView = datePicker
        detailsFoodView?.collectionView?.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        detailsFoodView?.collectionView?.delegate = self
        detailsFoodView?.collectionView?.dataSource = self
        
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
        view.endEditing(true)
    }
    
    @IBAction func addEventBtn(_ sender: Any) {
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if (granted) && (error == nil) {
                let event: EKEvent = EKEvent(eventStore: eventStore)
                event.title = self.viewModels?.name
                event.startDate = self.selectedDate
                event.endDate = self.selectedDate
                event.notes = "\(Auth.auth().currentUser?.email) Picked this Restaurant"
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
    
    
   private func loadDetails(width id: String) {
        service.request(.details(id: id)) { (result) in
            switch result {
            case .success(let response):
                let dataTest: JSON = JSON(response.data)
                print("data: \(dataTest)")
                if let details = try? self.jsonDecoder.decode(Details.self, from: response.data) {
                    print("details: \(details)")
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

