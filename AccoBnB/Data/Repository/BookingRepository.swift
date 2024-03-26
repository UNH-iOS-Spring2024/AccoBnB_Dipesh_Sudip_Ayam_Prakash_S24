//
//  BookingRepository.swift
//  AccoBnB
//
//  Created by AP on 20/03/2024.
//

import Foundation

protocol BookingRepository {
    // Create a new booking
    func createBooking(booking: Booking, completion: @escaping (Result<Booking, Error>) -> Void)
    
    // Read a booking by its ID
    func readBookingById(bookingId: String, completion: @escaping (Result<Booking?, Error>) -> Void)
    
    // Review a listing for a booking
    func reviewListing(review: Review, bookingId: String, completion: @escaping (Result<Review, Error>) -> Void)
    
    // Update an existing booking
    func updateBooking(bookingId: String, updatedBooking: Booking, completion: @escaping (Result<Booking, Error>) -> Void)
    
    // Delete a booking by its ID
    func deleteBooking(bookingId: String, completion: @escaping (Result<Bool, Error>) -> Void)
    
    // Get all bookings for a specific user
    func getUserBookings(userId: String, completion: @escaping (Result<[Booking], Error>) -> Void)
}
