//
//  RestaurantTableViewCell.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/26/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import AlamofireImage
class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImaveView: UIImageView!
    @IBOutlet weak var makerImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(with viewModel: RestaurantListViewModel) {
        print("Updating with \(viewModel)")
        restaurantImaveView.af_setImage(withURL: viewModel.imageUrl)
        restaurantNameLabel.text = viewModel.name
        locationLabel.text = viewModel.distance
    }
}
