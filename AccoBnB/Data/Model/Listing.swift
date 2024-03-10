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
    var isPublished: Bool? = false
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
}
// Extension for defining defaultListing
extension Listing {
    static let defaultListing: Listing = {
        let defaultAddress = Address(city: "New York", country: "United States", zipCode: "10001", addressLine1: "123 Main Street", addressLine2: "Apt 4B")
        let defaultGeoLocation = GeoLocation(lat: "40.7128", long: "-74.0060")
        
        return Listing(
            id: "1d8zkLVCHMoI8YyHgftu",
            hostId: "O0K3oA3xHKYXJBS57SIIc4DDP6I2",
            title: "68 Edwards St",
            description: "This is home",
            address: defaultAddress,
            geoLocation: defaultGeoLocation,
            status: .draft,
            monthlyPrice: 410.0,
            dailyPrice: 0.0,
            type: .rental,
            availableRooms: 1,
            guestCount: 0,
            bannerImage: "https://firebasestorage.googleapis.com/v0/b/accobnb-891d3.appspot.com/o/listings%2F96fc0e26-0d63-4548-ad1b-376e9e3082ee?alt=media&token=e11bb2b4-97b6-4889-87b2-a95c7d537254",
            imageGallery: [],
            views: 0,
            amenities: [],
            rating: 0.0,
            reviews: [],
            histories: [],
            isPublished: false
        )
    }()
}


