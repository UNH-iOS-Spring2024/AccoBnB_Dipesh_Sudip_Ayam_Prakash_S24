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
