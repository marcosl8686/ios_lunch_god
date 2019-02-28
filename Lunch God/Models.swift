//
//  Models.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/27/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation

struct Root: Codable {
    let businesses: [Business]
}

struct Business: Codable {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: Double
}

struct RestaurantListViewModel {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: String
}

extension RestaurantListViewModel {
    init(business: Business) {
        self.name = business.name
        self.id = business.id
        self.imageUrl = business.imageUrl
        self.distance = "\(business.distance / 1609.344)"
    }
}
