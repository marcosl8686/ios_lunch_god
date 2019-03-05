//
//  MyListTableViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/22/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class MyListTableViewController: UITableViewController {
    
    var viewModels = [RestaurantListViewModel]() {
        didSet{
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "My List"
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "myListCell", for: indexPath) as! RestaurantTableViewCell
        let vm = viewModels[indexPath.row]
        cell.configure(with: vm)
        
        return cell
    }

}
