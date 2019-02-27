//
//  AccessView.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/26/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

@IBDesignable class AccessView: BaseView {
    @IBOutlet weak var allowButton: UIButton!
    @IBOutlet weak var denyButton: UIButton!
    
    var didTapAllow: (() -> Void)?
    
    
    @IBAction func allowAction(_sender: UIButton) {
        didTapAllow?()
    }
    @IBAction func denyAction(_sender: UIButton) {
        
    }
}
