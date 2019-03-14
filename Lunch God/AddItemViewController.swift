//
//  AddItemViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/22/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import Moya
import SwiftyJSON
import CoreLocation


protocol ListAction: class {
    func didTapCell(_ viewModel: RestaurantListViewModel)
}

class AddItemViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var yelpSearch : [MyListDB] = [MyListDB]()
    var delegate: ListAction?
    let service = MoyaProvider<YelpService.BusinessProvider>()
    let jsonDecoder = JSONDecoder()
    @IBOutlet weak var yelpSearchBar: UITextField!
    @IBOutlet var searchTableView: UITableView!
    var viewModels = [RestaurantListViewModel]() {
        didSet{
            print("SET!")
            searchTableView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        //TODO: Set yourself as the delegate of the text field here:
        yelpSearchBar.delegate = self
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        searchTableView.register(UINib(nibName: "yelpSearchCell", bundle: nil), forCellReuseIdentifier: "yelpCustomCell")
        searchTableView.separatorStyle = .none
        configureTableView()
        self.parent?.title = "Search Restaurants"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yelpCustomCell", for: indexPath) as! YelpSearchTableViewCell
        let vm = viewModels[indexPath.row]
        print("View Model = \(vm)")
        cell.YelpSearchName.text = vm.name
        cell.YelpSearchImageView.af_setImage(withURL: vm.imageUrl)
        cell.YelpSearchPrice.text = vm.price
        cell.YelpSearchAddress.text = vm.location
        cell.YelpSearchDistance.text = vm.distance
        cell.YelpSearchType.text = vm.categories
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vm = viewModels[indexPath.row]
        print("Tab \(vm.id)")
        delegate?.didTapCell(vm)
        performSegue(withIdentifier: "goToAddEvent", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainViewController
        
        if let indexPath = searchTableView.indexPathForSelectedRow {
            destinationVC.selectedRestaurant = viewModels[indexPath.row]
        }
    }

    func configureTableView() {
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 200.0
    }
    
    @IBAction func yelpSendBtn(_ sender: Any) {
        let coordiates = CLLocationCoordinate2D()
        service.request(.search(lat: coordiates.latitude, long: coordiates.longitude, term: yelpSearchBar.text!)) { (result) in
            switch result {
            case .success(let response):
                let dataTest: JSON = JSON(response.data)
                print("data: \(dataTest)")
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                let viewModel = root?.businesses.compactMap(RestaurantListViewModel.init)
                self.viewModels = viewModel ?? []
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages() {
        let restaurantDB = Database.database().reference().child("restaurants")
        
        restaurantDB.observe(.childAdded) { (snapshot) in
            let snapshotValue =  snapshot.value as! Dictionary<String, String>
            
            let restName = snapshotValue["restaurantName"]!
            let date = snapshotValue["date"]!
            let imageUrl = snapshotValue["imageURL"]!
            let user = snapshotValue["user"]!
            print(restName, date, imageUrl, user)
            let restaurant = MyListDB()
            restaurant.restaurantName = restName
            restaurant.date = date
            restaurant.imageURL = imageUrl
            restaurant.user = user
            
            self.yelpSearch.append(restaurant)
        
            
        }
    }
    
}
