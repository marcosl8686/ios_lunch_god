//
//  YelpSearchTableViewCell.swift
//  Flash Chat
//
//  Created by Marcos Lee on 3/7/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class YelpSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var YelpSearchImageView: UIImageView!
    @IBOutlet weak var YelpSearchName: UILabel!
    @IBOutlet weak var YelpSearchReviewImg: UIImageView!
    @IBOutlet weak var YelpSearchReview: UILabel!
    @IBOutlet weak var YelpSearchAddress: UILabel!
    @IBOutlet weak var YelpSearchDistance: UILabel!
    @IBOutlet weak var YelpSearchPrice: UILabel!
    @IBOutlet weak var YelpSearchType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
