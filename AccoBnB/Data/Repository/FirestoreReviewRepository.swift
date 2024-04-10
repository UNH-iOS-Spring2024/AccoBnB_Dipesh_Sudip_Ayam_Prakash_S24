//
//  FirestoreReviewRepository.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/31/24.
//

import Foundation
import FirebaseFirestore

class FirestoreReviewRepository: ReviewRepository{
    
    private let db = Firestore.firestore()
    private let reviewsCollection = "reviews"
    
    func getReviewId() -> String {
        return db.collection(reviewsCollection).document().documentID
    }
    
    func createUserReview(userReview: Review) async throws {
        let encodedReview = try Firestore.Encoder().encode(userReview)
        try await db.collection(reviewsCollection).document(userReview.id).setData(encodedReview)
    }
    
    func getReviewsByListingId(for listingId: String, completion: @escaping (Result<[Review], Error>) -> Void){
        db.collection(reviewsCollection)
            .whereField("listingId",isEqualTo: listingId)
            .addSnapshotListener { snapshot, err in
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
