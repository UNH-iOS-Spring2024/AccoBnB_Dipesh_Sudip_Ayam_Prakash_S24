//
//  Listing.swift
//  AccoBnB
//
//  Created by AP on 26/02/2024.
//

import Foundation

struct Address: Codable {
    var city: String = ""
    var country: String = ""
    var zipCode: String = ""
    var addressLine1: String = ""
    var addressLine2: String = ""
}

struct GeoLocation: Codable {
    var lat: String = ""
    var long: String = ""
}

struct ListingHistory: Codable {
    var message: String = ""
    var type: String = ""
    var actorId: String = ""
    var role: UserRole 
}

enum ListingStatus: String, Codable {
    case available = "AVAILABLE"
    case sold = "SOLD"
    case draft = "DRAFT"
}

enum ListingType: String, Codable {
    case temporary = "TEMPORARY"
    case rental = "RENTAL"
}

enum Amenity: String, Codable {
    case wifi = "WIFI"
    case parking = "PARKING"
    case gym = "GYM"
    case airConditioning = "AIR_CONDITIONING"
    case heating = "HEATING"
    case tv = "TV"
    case kitchen = "KITCHEN"
    case washer = "WASHER"
    case dryer = "DRYER"
    case elevator = "ELEVATOR"
    case petFriendly = "PET_FRIENDLY"
    case balcony = "BALCONY"
}

struct Listing: Codable {
    var id: String = ""
    var hostId: String = ""
    var title: String = ""
    var description: String = ""
    var address: Address? = nil
    var geoLocation: GeoLocation? = nil
    var geoHash: String? = nil
    var status: ListingStatus = .draft
    var monthlyPrice: Float = 0.0 // if rental
    var dailyPrice: Float = 0.0 // if temporary
    var type: ListingType = .rental // Temporary, Rental
    var availableRooms: Int = 0 // if rental
    var guestCount: Int = 0 // if temporary
    var bannerImage: String = ""
    var imageGallery: [String] = []
    var views: Int = 0
    var amenities: [Amenity] = []
    var availableFrom: Date? = nil
    var rating: Float = 0.0
    var reviews: [Review] = []
    var histories: [ListingHistory] = []
    var isPublished: Bool = false
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
}

