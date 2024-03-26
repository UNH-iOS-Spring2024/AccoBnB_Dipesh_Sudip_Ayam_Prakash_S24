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
    private let authViewModel: AuthViewModel
    
    init(bookingRepository: BookingRepository = FirestoreBookingRepository(),authViewModel: AuthViewModel, text: String = "") {
        self.bookingRepository = bookingRepository
        self.authViewModel = authViewModel
        print("BookingViewModel initialized with text: \(text)")
        getUserBooking(userId: authViewModel.userSession!.uid)
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
        let booking = Booking(
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
            DispatchQueue.main.async {
                switch result {
                case .success(let newBooking):
                    self?.bookings.append(newBooking)
                    completion(.success(newBooking))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    
    
}

