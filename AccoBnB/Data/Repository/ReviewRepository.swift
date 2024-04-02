//
//  ReviewRepository.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/31/24.
//

import Foundation

protocol ReviewRepository {
    
    func getReviewId() -> String
    func createUserReview(userReview: Review) async throws
    func getReviewsByListingId(for listingId: String, completion: @escaping (Result<[Review], Error>) -> Void)
}
