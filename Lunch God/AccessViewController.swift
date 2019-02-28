//
//  AccessViewController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/26/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class AccessViewController: UIViewController {
    @IBOutlet weak var accessView: AccessView!
    var locationService: LocationServices?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        accessView.didTapAllow = {[weak self] in
            self?.locationService?.requestLocationAuthorization()
        }
        
        locationService?.didChangeStatus = {[weak self] success in
            if success {
                self?.locationService?.getLocation()
            }
        }
        locationService?.newLocation = {[weak self] result in
            switch result {
            case .success(let location):
                print(location)
            case .failure(let error):
                print("Error getting the users location \(error)")
            }
        }
    }
}
