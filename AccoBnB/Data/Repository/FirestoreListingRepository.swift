//
//  FirebaseListingRepository.swift
//  AccoBnB
//
//  Created by AP on 05/03/2024.
//

import Foundation
import FirebaseFirestore

class FirestoreListingRepository: ListingRepository {
    private let db = Firestore.firestore()
    private let listingsCollection = "listings" // Firestore collection name

    func getAllListings(completion: @escaping (Result<[Listing], Error>) -> Void) {
        db.collection(listingsCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let listings = documents.compactMap { document -> Listing? in
                let result = Result {
                    try document.data(as: Listing.self)
                }
                switch result {
                case .success(let listing):
                    return listing
                case .failure(let error):
                    print("Error decoding listing: \(error)")
                    return nil
                }
            }

            completion(.success(listings))
        }
    }
}
