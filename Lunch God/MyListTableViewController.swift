//
//  MyListTableViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/22/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Firebase

class MyListTableViewController: UITableViewController {
    var yelpSearch : [MyListDB] = [MyListDB]() {
        didSet{
            print("DB received from FB")
            tableView.reloadData()
        }
    }
    var viewModels = [RestaurantListViewModel]() {
        didSet{
            print("SET 2")
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "My List"
        tableView.register(UINib(nibName: "yelpSearchCell", bundle: nil), forCellReuseIdentifier: "yelpCustomCell")
        tableView.separatorStyle = .none
        retrieveRestList()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return yelpSearch.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "yelpCustomCell", for: indexPath) as! YelpSearchTableViewCell
        let vm = yelpSearch[indexPath.row]
        let imageUrlLink = URL(string: vm.imageURL)
        cell.YelpSearchName.text = vm.restaurantName
        cell.YelpSearchDistance.text = vm.distance
        cell.YelpSearchImageView.af_setImage(withURL: imageUrlLink!)

        return cell
    }
    
    
    //TODO: Create the retrieveMessages method here:
    func retrieveRestList() {
        let restaurantDB = Database.database().reference().child(Auth.auth().currentUser!.uid)
        
        restaurantDB.observe(.childAdded) { (snapshot) in
            let snapshotValue =  snapshot.value as! Dictionary<String, String>
            let restName = snapshotValue["name"]!
            let imageUrl = snapshotValue["imageUrl"]!
            let user = snapshotValue["user"]!
            let uId = snapshotValue["id"]!
            let distance = snapshotValue["distance"]!
            let price = snapshotValue["price"]!
            
            print("Firebase Pulling  - \(snapshotValue)")
            let restaurant = MyListDB()
            restaurant.restaurantName = restName
            restaurant.imageURL = imageUrl
            restaurant.user = user
            restaurant.distance = distance
            restaurant.price = price
            restaurant.id = uId
            print("FB RestLit \(restaurant)")
            
            self.yelpSearch.append(restaurant)
            
            
        }
    }

}
