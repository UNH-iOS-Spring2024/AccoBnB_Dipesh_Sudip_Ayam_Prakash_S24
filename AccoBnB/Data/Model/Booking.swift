//
//  Booking.swift
//  AccoBnB
//
//  Created by AP on 26/02/2024.
//

import Foundation

enum BookingStatus: String, Codable {
    case approved = "Approved"
    case pending = "Pending"
    case rejected = "Rejected"
}

struct Booking: Codable {
    var id: String? = ""
    var userId: String = ""
    var listingId: String = ""
    var listingInfo: Listing? = nil // New property to store listing info
    var userInfo: User? = nil
    var checkInDate: Date? = nil
    var checkOutDate: Date? = nil
    var bookingNote: String = ""
    var totalAmount: Float = 0.0
    var hasReviewed: Bool? = false
    var status: BookingStatus = .pending
    var createdAt: Date
    var updatedAt: Date? = nil
}

extension Booking {
    static var defaultBooking: Booking {
        return Booking(
            id: "Ft0fGb0gKlcPlNKjkPKE",
            userId: "413mr3E1S3M1Bu5Yc0UeYI7Bx9P2",
            listingId: "7XzzCJQ76AWvtzLV7e4g",
            listingInfo: Listing.defaultListing,
            userInfo: User.defaultGuestUser,
            bookingNote: "This is a book now",
            totalAmount: 20.0,
            status: .approved,
            createdAt: Date(timeIntervalSince1970: 1676896428),
            updatedAt: Date(timeIntervalSince1970: 1676896463)
        )
    }
}



