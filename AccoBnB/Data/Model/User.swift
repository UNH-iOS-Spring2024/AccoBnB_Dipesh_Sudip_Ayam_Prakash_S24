//
//  User.swift
//  AccoBnB
//
//  Created by AP on 26/02/2024.
//

import Foundation

import Foundation

struct User: Codable {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var profileImage: String = ""
    var email: String = ""
    var role: UserRole = .guest
    var fcmToken: String = ""
    var address: Address? = nil
    var preference: UserPreference? = nil
    var favourites: [Favourite] = [] // discuss and add if we are adding add to favorite feature to the app
}

struct UserPreference: Codable {
    var darkMode: Bool
    var budget: Float
}

enum UserRole: String, Codable {
    case admin = "ADMIN"
    case guest = "GUEST"
    case host = "HOST"
}
