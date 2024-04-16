//
//  BookingViewModel.swift
//  AccoBnB
//
//  Created by AP on 20/03/2024.
//

import Foundation

final class BookingViewModel : ObservableObject {
    @Published var bookings: [Booking] = []
    @Published var isLoading = false // Track loading state
    private let bookingRepository: BookingRepository
    
    init(bookingRepository: BookingRepository = FirestoreBookingRepository()) {
        self.bookingRepository = bookingRepository
    }
    
    func getUserBooking(userId: String) {
        isLoading = true // Show loader
        bookingRepository.getUserBookings(userId: userId) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let bookings):
                DispatchQueue.main.async {
                    print("Booking loaded",bookings)
                    self?.bookings = bookings
                }
            case .failure(let error):
                print("Failed to fetch bookings: \(error)")
                // Handle error, such as showing an alert to the user
            }
        }
    }
    
    func createBooking(userId: String, listingId: String, bookingNote: String, completion: @escaping (Result<Booking, Error>) -> Void) {
        
        isLoading = true // Show loader
        let booking = Booking(
            id: bookingRepository.getBookingId(),
            userId: userId,
            listingId: listingId,
            listingInfo: nil,
            checkInDate: nil,
            checkOutDate: nil,
            bookingNote: bookingNote,
            totalAmount: 0.0,
            createdAt: Date(),
            updatedAt: nil
        )
        
        bookingRepository.createBooking(booking: booking) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            DispatchQueue.main.async {
                switch result {
                case .success(let newBooking):
                    completion(.success(newBooking))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    func updateBooking(booking: Booking, completion: @escaping (Result<Booking, Error>) -> Void) {
        isLoading = true
        bookingRepository.updateBooking(updatedBooking: booking){[weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let updatedBooking):
                DispatchQueue.main.async {
                    // Update the existing listing in the list with the updated one
                    if let index = self?.bookings.firstIndex(where: { $0.id == updatedBooking.id }) {
                        self?.bookings[index] = updatedBooking
                    }
                    completion(.success(updatedBooking))
                }
            case .failure(let error):
                print("Failed to update booking: \(error)")
                // Handle error, such as showing an alert to the user
                completion(.failure(error)) // Pass back the error
            }
        }
        
    }
    
    func getBookingById(bookingId: String, completion: @escaping (Result<Booking?, Error>) -> Void) {
        isLoading = true // Show loader
        bookingRepository.getBookingDetailById(bookingId: bookingId) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let booking):
                DispatchQueue.main.async {
                    completion(.success(booking))
                }
            case .failure(let error):
                print("Failed to fetch booking by id: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    
    
    
    
}

