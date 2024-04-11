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

enum Amenity: String, Codable, CaseIterable  {
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
    var address: Address = Address()
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
    var amenities: Set<Amenity> = []
    var availableFrom: Date? = nil
    var rating: Float = 0.0
    var reviews: [Review] = []
    var histories: [ListingHistory] = []
    var isPublished: Bool? = true
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
            bannerImage: "https://firebasestorage.googleapis.com/v0/b/accobnb-891d3.appspot.com/o/listings%2F257059ba-64a3-4774-8114-45ceb182bd2a?alt=media&token=6b745036-db1c-4fb1-aa9c-7e3092255720",
            imageGallery: [],
            views: 0,
            amenities: [],
            rating: 0.0,
            reviews: [AccoBnB.Review(id: "B7sjWb8WgvRkcBvGjn0g", reviewerId: "lVaKNAatVObr6hDVD2R6JpycInf1", listingId: "TKYRfDrqM2Vwg1UKsyZ7", rating: 4.0, comment: "Wow! I had an amazing stay.", date: Date()), AccoBnB.Review(id: "Cxhu6vt0Oe11PuSrimHU", reviewerId: "lVaKNAatVObr6hDVD2R6JpycInf1", listingId: "TKYRfDrqM2Vwg1UKsyZ7", rating: 4.0, comment: "It was good.", date: Date()), AccoBnB.Review(id: "LBVoa7koqkLK5btQ8jd1", reviewerId: "lVaKNAatVObr6hDVD2R6JpycInf1", listingId: "TKYRfDrqM2Vwg1UKsyZ7", rating: 4.0, comment: "This is a place i would like to visit again if time permits.sdjflkjsdlkfjlsdjfljlsdjfjlsjlkfjsdkljfkjsdljlfksjlkjflkjsdljflsjlksjfljdlksjflkjalskdjflkjsdlkfjlksjldfk", date: Date()), AccoBnB.Review(id: "Lhu2l6pxvzAMAWlKwdGv", reviewerId: "lVaKNAatVObr6hDVD2R6JpycInf1", listingId: "TKYRfDrqM2Vwg1UKsyZ7", rating: 5.0, comment: "This is brilliant flat", date: Date())],
            histories: [],
            isPublished: false
        )
    }()
}


