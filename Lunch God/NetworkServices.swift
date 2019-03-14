//
//  NetworkServices.swift
//  Flash Chat
//
//  Created by Marcos Lee on 2/27/19.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import Foundation
import Moya

private let apiKey = "bGZz4X0o65g0mqQjrImYz62mrk3et_ygxV52mVIiipWTVztBDUhth7rghNB2_hMgQBJTxYWDC0TMESHanRo2svXwKqzFXLLU5-U2HTzq8bImLQuev4YHGhIvNZhzXHYx"

enum YelpService {
    enum BusinessProvider: TargetType {
        case search(lat: Double, long: Double, term: String)
        case details(id: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
            }
        }
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(lat, long, term):
                return .requestParameters(
                    parameters: ["latitude": lat, "longitude": long, "term": term, "limit": 10], encoding: URLEncoding.queryString)
            case .details:
                return .requestPlain
            }
        }
        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}
