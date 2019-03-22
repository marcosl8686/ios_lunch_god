//
//  ScheduleCell.swift
//  Flash Chat
//
//  Created by Marcos Lee on 3/21/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var scheduleRestImage: UIImageView!
    @IBOutlet weak var scheduleRestName: UILabel!
    @IBOutlet weak var scheduleDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
