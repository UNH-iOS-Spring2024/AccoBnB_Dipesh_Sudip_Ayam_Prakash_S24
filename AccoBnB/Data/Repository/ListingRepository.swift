//
//  ListingRepository.swift
//  AccoBnB
//
//  Created by AP on 05/03/2024.
//

import Foundation
import UIKit

protocol ListingRepository {
    func getAllActiveListings(userId: String?,completion: @escaping (Result<[Listing], Error>) -> Void)
    func getAllActiveListings(completion: @escaping (Result<[Listing], Error>) -> Void)
    func getListingId() -> String
    func setListing(bannerImagePath: UIImage?, listing: Listing, completion: @escaping (Result<Listing, Error>) -> Void)
    func getListingById(listingId: String, completion: @escaping (Result<Listing?, Error>) -> Void)
}
