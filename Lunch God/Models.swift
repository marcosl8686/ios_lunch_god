//
//  Models.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/27/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

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

struct Details: Decodable {
    let price: String
    let phone: String
    let isClosed: Bool
    let rating: Double
    let name: String
    let photos: [URL]
    let coordinates: CLLocationCoordinate2D
}

extension CLLocationCoordinate2D: Decodable {
    enum CodingKeys: CodingKey {
        case latitude
        case longitude
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        self.init(latitude: latitude, longitude: longitude)
    }
}

struct DetailsViewModel {
    let price: String
    let isOpen: String
    let phoneNumber: String
    let rating: String
    let imageUrls: [URL]
    let coordinate: CLLocationCoordinate2D
    let name: String
}

extension DetailsViewModel {
    init(details: Details) {
        self.price = details.price
        self.isOpen = details.isClosed ? "Closed": "Open"
        self.phoneNumber = details.phone
        self.rating = "\(details.rating) / 5"
        self.imageUrls = details.photos
        self.coordinate = details.coordinates
        self.name = details.name
    }
}
