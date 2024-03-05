//
//  Favourite.swift
//  AccoBnB
//
//  Created by AP on 26/02/2024.
//

import Foundation

struct Favourite: Codable {
    var id: String
    var listingId: String
    var listingName: String
    var date: Date
    var owner: String
}
