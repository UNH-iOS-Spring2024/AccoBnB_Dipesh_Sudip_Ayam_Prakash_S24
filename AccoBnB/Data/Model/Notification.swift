//
//  Notification.swift
//  AccoBnB
//
//  Created by AP on 26/02/2024.
//

import Foundation

struct Notification: Codable {
    var id: String = ""
    var receiverId: String = ""
    var senderId: String = ""
    var listingId: String = ""
    var bookingId: String = ""
    var title: String = ""
    var message: String = ""
    var createdAt: Date? = nil
    var type: String = ""
}
