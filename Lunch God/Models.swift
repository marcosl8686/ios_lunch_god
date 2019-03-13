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
    let price: String
    struct location : Codable {
        let address1: String
        let city: String
    }
    struct Category : Codable {
        let title: String
    }
    let categories: [Category]
    let location: location
}

struct RestaurantListViewModel {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: String
    let price: String
    let location: String
    let categories: String
}

extension RestaurantListViewModel {
    init(business: Business) {
        print("business: \(business)")
        self.name = business.name
        self.id = business.id
        self.imageUrl = business.imageUrl
        self.distance = String(format: "%.2f", business.distance / 1609.344)
        self.price = business.price
        self.location = "\(business.location.address1) \(business.location.city)"
        self.categories = business.categories[0].title
    }
}
