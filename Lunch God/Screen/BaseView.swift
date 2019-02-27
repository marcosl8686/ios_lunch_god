//
//  BaseView.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/26/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

@IBDesignable class BaseView: UIView {
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configure()
    }
    func configure() {
        
    }
}


