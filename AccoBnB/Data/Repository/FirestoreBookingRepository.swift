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
    
    func getBookingDetailById(bookingId: String, completion: @escaping (Result<Booking?, Error>) -> Void) {
        db.collection(bookingsCollection).document(bookingId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = snapshot?.data() {
                do {
                    var booking = try Firestore.Decoder().decode(Booking.self, from: data)
                    // Fetch listing info for the booking
                    let listingId = booking.listingId
                    let listingDocRef = self.db.collection(self.listingsCollection).document(listingId)
                    listingDocRef.getDocument { (listingSnapshot, listingError) in
                        if let listingError = listingError {
                            print("Error fetching listing: \(listingError)")
                            // If there's an error fetching listing info, set booking as nil and complete
                            completion(.success(nil))
                            return
                        }
                        
                        if let listingData = listingSnapshot?.data() {
                            do {
                                let listing = try Firestore.Decoder().decode(Listing.self, from: listingData)
                                booking.listingInfo = listing
                            } catch {
                                print("Error decoding listing data:", error)
                            }
                        }
                        
                        // Fetch user info for the booking
                        let userDocRef = self.db.collection(self.userCollections).document(booking.userId)
                        userDocRef.getDocument { (userSnapshot, userError) in
                            if let userError = userError {
                                print("Error fetching user info: \(userError)")
                                // If there's an error fetching user info, set booking as nil and complete
                                completion(.success(nil))
                                return
                            }
                            
                            if let userData = userSnapshot?.data() {
                                do {
                                    let user = try Firestore.Decoder().decode(User.self, from: userData)
                                    booking.userInfo = user
                                } catch {
                                    print("Error decoding user data:", error)
                                }
                            }
                            
                            // Complete with the updated booking
                            completion(.success(booking))
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.success(nil))
            }
        }
    }

    
    func updateBooking(updatedBooking: Booking, completion: @escaping (Result<Booking, Error>) -> Void) {
        do {
            let updatedBooking = updatedBooking
            try db.collection(bookingsCollection).document(updatedBooking.id!).setData(from: updatedBooking) { error in
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
//    
//    func getUserBookings(userId: String, completion: @escaping (Result<[Booking], Error>) -> Void) {
//        var query = db.collection(bookingsCollection).whereField("userId", isEqualTo: userId)
//        // Add a snapshot listener to listen for real-time updates
//        query.addSnapshotListener { [weak self] snapshot, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let documents = snapshot?.documents else {
//                completion(.success([]))
//                return
//            }
//            
//            var bookings: [Booking] = []
//            let dispatchGroup = DispatchGroup()
//            let dispatchQueue = DispatchQueue(label: "com.accobnb.fetchUserBookings", attributes: .concurrent)
//            
//            for document in documents {
//                dispatchGroup.enter()
//                guard var booking = try? document.data(as: Booking.self) else {
//                    print("Error decoding booking data")
//                    dispatchGroup.leave()
//                    continue
//                }
//                
//                let listingId = booking.listingId
//                let userFetchGroup = DispatchGroup()
//                var fetchedListing: Listing?
//                var fetchedUser: User?
//                
//                // Fetch listing and user data concurrently
//                dispatchQueue.async(group: userFetchGroup) {
//                    let listingDocRef = self?.db.collection(self?.listingsCollection ?? "").document(listingId)
//                    listingDocRef?.getDocument { listingSnapshot, listingError in
//                        defer { userFetchGroup.leave() }
//                        
//                        if let listingError = listingError {
//                            print("Error fetching listing: \(listingError)")
//                            return
//                        }
//                        
//                        if let listingData = listingSnapshot?.data() {
//                            do {
//                                fetchedListing = try Firestore.Decoder().decode(Listing.self, from: listingData)
//                            } catch {
//                                print("Error decoding listing data:", error)
//                            }
//                        }
//                    }
//                    
//                    let userDocRef = self?.db.collection(self?.userCollections ?? "").document(booking.userId)
//                    userDocRef?.getDocument { userSnapshot, userError in
//                        defer { userFetchGroup.leave() }
//                        
//                        if let userError = userError {
//                            print("Error fetching user info: \(userError)")
//                            return
//                        }
//                        
//                        if let userData = userSnapshot?.data() {
//                            do {
//                                fetchedUser = try Firestore.Decoder().decode(User.self, from: userData)
//                            } catch {
//                                print("Error decoding user data:", error)
//                            }
//                        }
//                    }
//                }
//                
//                // Wait for both listing and user data to be fetched
//                userFetchGroup.notify(queue: .main) {
//                    booking.listingInfo = fetchedListing
//                    booking.userInfo = fetchedUser
//                    bookings.append(booking)
//                    dispatchGroup.leave()
//                }
//            }
//            
//            dispatchGroup.notify(queue: .main) {
//                completion(.success(bookings))
//            }
//        }
//    }

    
    func getUserBookings(userId: String, completion: @escaping (Result<[Booking], Error>) -> Void) {
        db.collection(bookingsCollection)
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { snapshot, error in
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
                                        let listing = try Firestore.Decoder().decode(Listing.self, from: listingData)
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
                                            let user = try Firestore.Decoder().decode(User.self, from: userData)
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
