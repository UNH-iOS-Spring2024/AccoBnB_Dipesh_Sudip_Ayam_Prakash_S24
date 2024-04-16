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
    static let defaultHostUser: User = {
        let defaultAddress = Address(city: "New York", country: "United States", zipCode: "10001", addressLine1: "123 Main Street", addressLine2: "Apt 4B")
        let defaultPreference = UserPreference(darkMode: false, budget: 1000.0)
        return User(
            id: "xap9z81gb2XFsULfi5mAsvWme792",
            firstName: "Sudip",
            lastName: "Host",
            phone: "",
            profileImage: "https://firebasestorage.googleapis.com:443/v0/b/accobnb-891d3.appspot.com/o/profiles%2FFB3F67B5-389D-4E90-8834-326D010E6C90?alt=media&token=24987c44-623f-4282-abf7-518863d0ede4",
            email: "host@gmail.com",
            role: .host,
            fcmIosToken: "",
            address: defaultAddress,
            preference: defaultPreference,
            favourites: []
        )
       
    }()
    
    static let defaultGuestUser: User = {
        let defaultAddress = Address(city: "New York", country: "United States", zipCode: "10001", addressLine1: "123 Main Street", addressLine2: "Apt 4B")
        let defaultPreference = UserPreference(darkMode: false, budget: 1000.0)
        return User(
            id: "jHWZTnWxDWMuhcEvueuBFUXmou63",
            firstName: "Dipesh",
            lastName: "Shrestha",
            phone: "",
            profileImage: "",
            email: "dipesh@gmail.com",
            role: .guest,
            fcmIosToken: "",
            address: defaultAddress,
            preference: defaultPreference,
            favourites: []
        )
       
    }()
}

