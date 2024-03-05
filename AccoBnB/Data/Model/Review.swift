//
//  Review.swift
//  AccoBnB
//
//  Created by AP on 26/02/2024.
//

import Foundation

struct Review: Codable {
    var id: String = ""
    var reviewerId: String = ""
    var listingId: String = ""
    var rating: Float = 0.0
    var comment: String = ""
    var date: String = ""
}
