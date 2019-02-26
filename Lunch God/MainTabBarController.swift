//
//  MainTabBarController.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/24/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    @IBAction func openCalendarBtn(_ sender: Any) {
        print("clicked Calendar")
        open(scheme: "calshow://")
    }
    
    func open(scheme: String) {
        if let url = URL(string: scheme) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                  completionHandler: {
                    (success) in
                    print("Open \(scheme): \(success)")
                })
            } else {
                let success = UIApplication.shared.openURL(url)
                print("Open \(scheme): \(success)")
            }
        }
    }
}
