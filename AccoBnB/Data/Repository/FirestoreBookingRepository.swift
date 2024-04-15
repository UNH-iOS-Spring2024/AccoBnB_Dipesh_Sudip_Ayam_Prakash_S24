//
//  FirestoreBookingRepository.swift
//  AccoBnB
//
//  Created by AP on 20/03/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirestoreBookingRepository: BookingRepository {
    
    let db = Firestore.firestore()
    private let bookingsCollection = "bookings"
    private let listingsCollection = "listings"
    private let userCollections = "users"
    
    func getBookingId() -> String {
        return db.collection(bookingsCollection).document().documentID
    }
    
    func createBooking(booking: Booking, completion: @escaping (Result<Booking, Error>) -> Void) {
        do {
            try db.collection(bookingsCollection).document(booking.id!).setData(Firestore.Encoder().encode(booking)){ error in
                if let error = error {
                    print("Error while booking: \(error)")
                    completion(.failure(error))
                } else {
                    completion(.success(booking))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    
    
    func readBookingById(bookingId: String, completion: @escaping (Result<Booking?, Error>) -> Void) {
        db.collection(bookingsCollection).document(bookingId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = snapshot?.data() {
                do {
                    let booking = try Firestore.Decoder().decode(Booking.self, from: data)
                    completion(.success(booking))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func updateBooking(bookingId: String, updatedBooking: Booking, completion: @escaping (Result<Booking, Error>) -> Void) {
        do {
            var updatedBooking = updatedBooking
            updatedBooking.id = bookingId
            try db.collection(bookingsCollection).document(bookingId).setData(from: updatedBooking) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(updatedBooking))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func reviewListing(review: Review, bookingId: String, completion: @escaping (Result<Review, Error>) -> Void) {
        // Implement reviewListing method here
    }
    
    func deleteBooking(bookingId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection(bookingsCollection).document(bookingId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }
    
    //    func getUserBookings(userId: String, completion: @escaping (Result<[Booking], Error>) -> Void) {
    //        print("userid from repo:\(userId)")
    //        db.collection(bookingsCollection).whereField("userId", isEqualTo: userId).getDocuments { snapshot, error in
    //            if let error = error {
    //                completion(.failure(error))
    //            } else if let snapshot = snapshot {
    //                do {
    //                    let bookings = try snapshot.documents.compactMap {
    //                        try $0.data(as: Booking.self)
    //                    }
    //                    completion(.success(bookings))
    //                } catch {
    //                    completion(.failure(error))
    //                }
    //            }
    //        }
    //    }
    func getUserBookings(userId: String, completion: @escaping (Result<[Booking], Error>) -> Void) {
        db.collection(bookingsCollection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    var bookings: [Booking] = []
                    for document in snapshot.documents {
                        if var booking = try? document.data(as: Booking.self) {
                            // Fetch listing info for the booking
                            let listingId = booking.listingId
                            let listingDocRef = self.db.collection(self.listingsCollection).document(listingId)
                            listingDocRef.getDocument { (listingSnapshot, listingError) in
                                if let listingError = listingError {
                                    print("Error fetching listing: \(listingError)")
                                    // If there's an error fetching listing info, still add the booking without listing info
                                    bookings.append(booking)
                                    return
                                }
                                
                                if let listingData = listingSnapshot?.data() {
                                    do {
                                        let jsonData = try JSONSerialization.data(withJSONObject: listingData)
                                        let listing = try JSONDecoder().decode(Listing.self, from: jsonData)
                                        booking.listingInfo = listing
                                    } catch {
                                        print("Error decoding listing data:", error)
                                    }
                                }
                                self.db.collection(self.userCollections).document(booking.userId).getDocument{
                                    (userSnapshot,userError) in
                                    if let userError = userError{
                                        print("Error fetching user info: \(userError)")
                                        // If there's an error fetching user info, still add the booking without listing info
                                        bookings.append(booking)
                                        return
                                    }
                                    if let userData = userSnapshot?.data() {
                                        do {
                                            let jsonData = try JSONSerialization.data(withJSONObject: userData)
                                            let user = try JSONDecoder().decode(User.self, from: jsonData)
                                            booking.userInfo = user
                                        } catch {
                                            print("Error decoding listing data:", error)
                                        }
                                    }
                                    // Add the booking (with or without listing/booking info) to the array
                                    bookings.append(booking)
                                    
                                    // Check if all bookings have been processed and call the completion handler
                                    if bookings.count == snapshot.documents.count {
                                        completion(.success(bookings))
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
    
    
    
    
    
    
}
