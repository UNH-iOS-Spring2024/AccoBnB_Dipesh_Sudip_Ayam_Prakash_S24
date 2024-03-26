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
    private let reviewsCollection = "reviews"

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
            
            var listings: [Listing] = []
            // Using dispatcher group to synchronize all asynchronous tasks. Here it ensures that the completion handler is called only after all asynchronous tasks related to fetching listings and their reviews are completed.
            // If we don't use DispatchGroup() only listings will be returned while reviews will be retrieved later async-.
            let dispatchGroup = DispatchGroup()
            
            for document in documents{
                dispatchGroup.enter()
                
                let result = Result{
                    try? document.data(as: Listing.self)
                }
                
                switch result{
                case .success(let listing):
                    if var listing = listing{
                        // Fetch reviews for current listing:
                        self.fetchReviews(for: listing.id){result in
                            switch(result){
                            case .success(let reviews):
                                listing.reviews = reviews
                                listings.append(listing)
                            case .failure(let error):
                                print("Error in fetching reviews \(error)")
                            }
                            dispatchGroup.leave()
                        }
                    }
                case .failure(let error):
                    print("Error decoding listing: \(error)")
                    dispatchGroup.leave()                }
            }
            dispatchGroup.notify(queue: .main) {
                completion(.success(listings))
            }
        }
    }
    
    private func fetchReviews(for listingId: String, completion: @escaping (Result<[Review], Error>) -> Void){
        db.collection(reviewsCollection)
            .whereField("listingId",isEqualTo: listingId)
            .getDocuments { snapshot, err in
                if let error = err{
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else{
                    completion(.success([]))
                    return
                }
                
                let reviews = documents.compactMap { document -> Review? in
                    let result = Result{
                        try document.data(as: Review.self)
                    }
                    switch result{
                    case .success(let review):
                        return review
                    case .failure(let error):
                        print("Error in decoding review \(error)")
                        return nil
                    }
                }
                completion(.success(reviews))
            }
    }
}
