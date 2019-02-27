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
    override func viewDidLoad() {
        super.viewDidLoad()

        accessView.didTapAllow = {[weak self] in
            print("OK")
        }
        // Do any additional setup after loading the view.
    }
}
