//
//  MyListTableViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/22/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class MyListTableViewController: UITableViewController {
    @IBAction func AddListBtn(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.parent?.title = "My List"
    }

}
