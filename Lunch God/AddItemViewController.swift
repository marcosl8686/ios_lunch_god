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

class AddItemViewController: UIViewController, UITextFieldDelegate {
    var yelpSearch : [MyListDB] = [MyListDB]()
    let service = MoyaProvider<YelpService.BusinessProvider>()

    @IBOutlet weak var yelpSearchBar: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "Search Restaurants"
    }

    @IBAction func SearchBtn(_ sender: AnyObject) {
        let restaurantDB = Database.database().reference().child("restaurant")
        let restaurantDictionary = ["restaurantName": Auth.auth().currentUser?.email, "date": Auth.auth().currentUser?.email, "imageUrl": Auth.auth().currentUser?.email, "user": Auth.auth().currentUser?.email,]
        
        restaurantDB.childByAutoId().setValue(restaurantDictionary) {
            (error, reference) in
            if error != nil {
                print(error!)
            } else {
                print("Message saved Successfully")
            }
        }
        
    }
    
    @IBAction func yelpSendBtn(_ sender: Any) {
        service.request(.search(lat: 29.973330, long: -95.687332)) { (result) in
            switch result {
            case .success(let response):
                print(try? JSONSerialization.jsonObject(with: response.data, options:[]))
                
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
