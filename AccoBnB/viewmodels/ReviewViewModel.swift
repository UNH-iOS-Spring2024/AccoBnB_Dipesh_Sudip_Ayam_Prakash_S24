//
//  ReviewViewModel.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/31/24.
//

import Foundation

class ReviewViewModel: ObservableObject {
    
    private let reviewRepository: ReviewRepository
    private let authViewModel = AuthViewModel()
    
    init(reviewRepository: ReviewRepository = FirestoreReviewRepository()) {
        self.reviewRepository = reviewRepository
    }
    
    func createUserReview(reviewerId: String, listingId: String, rating: Float, comment: String, date: Date) async throws{
        do {
            let newReview = Review(
                id: reviewRepository.getReviewId(),
                reviewerId: reviewerId,
                reviewerName: "\(authViewModel.currentUser?.firstName ?? "") \(authViewModel.currentUser?.lastName ?? "")",
                listingId: listingId,
                rating: rating,
                comment: comment,
                date: date
            )
            try await reviewRepository.createUserReview(userReview: newReview)
//            print("\nReview update ----> \(newReview)")
        } catch {
            print("DEBUG: Error in creating user review with error \(error) ")
        }
    }
    
    // func getReviewsByListingId(for listingId: String, completion: @escaping (Result<[Review], Error>) -> Void){
    //     reviewRepository.getReviewsByListingId(for: listingId) { result in
    //         switch result {
    //         case .success(let reviews):
    //             completion(.success(reviews))
    //         case .failure(let error):
    //             completion(.failure(error))
    //         }
    //     }
    // }
}
