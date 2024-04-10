//
//  User.swift
//  AccoBnB
//
//  Created by AP on 26/02/2024.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var phone: String = ""
    var profileImage: String = ""
    var email: String = ""
    var role: UserRole = .guest
    var fcmIosToken: String? = "" //made it optional till we add authentication logic
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


// extension for defining default user
extension User {
    static let defaultUser: User = {
        let defaultAddress = Address(city: "New York", country: "United States", zipCode: "10001", addressLine1: "123 Main Street", addressLine2: "Apt 4B")
        let defaultPreference = UserPreference(darkMode: false, budget: 1000.0)
        return User(
            id: "xap9z81gb2XFsULfi5mAsvWme792",
            firstName: "test",
            lastName: "Host",
            phone: "",
            profileImage: "https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg",
            email: "dipesh@gmail.com",
            role: .host,
            fcmIosToken: "",
            address: defaultAddress,
            preference: defaultPreference,
            favourites: []
        )
       
    }()
}

