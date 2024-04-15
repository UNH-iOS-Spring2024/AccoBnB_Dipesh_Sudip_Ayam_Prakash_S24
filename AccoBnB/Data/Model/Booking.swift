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
    var createdAt: Date? = nil
    var updatedAt: Date? = nil
}

extension Booking {
    static var defaultBooking: Booking {
        return Booking(
            id:"xap9z81gb2XFsULfi5mAsvWme792",
            userId: "xap9z81gb2XFsULfi5mAsvWme792",
            listingId: "1M4QVd7B2lEzz6ivpRtB",
            listingInfo: Listing.defaultListing,
            userInfo: User.defaultUser,
            bookingNote: "Default bookingDefault bookingDefault bookingDefault bookingDefault booking",
            totalAmount: 0.0, // or any default amount you want
            status: .pending,
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}

