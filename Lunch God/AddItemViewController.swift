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

class AddItemViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var yelpSearch : [MyListDB] = [MyListDB]()
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
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func configureTableView() {
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.estimatedRowHeight = 120.0
    }
    
    @IBAction func yelpSendBtn(_ sender: Any) {
        service.request(.search(lat: 29.973330, long: -95.687332)) { (result) in
            switch result {
            case .success(let response):
                let root = try? self.jsonDecoder.decode(Root.self, from: response.data)
                let viewModel = root?.businesses.compactMap(RestaurantListViewModel.init)
                self.viewModels = viewModel ?? []
                print(viewModel)
                
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
