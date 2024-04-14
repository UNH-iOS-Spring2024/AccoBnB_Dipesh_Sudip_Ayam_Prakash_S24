//
//  ListingViewModel.swift
//  AccoBnB
//
//  Created by AP on 05/03/2024.
//

import Foundation
import UIKit

final class ListingViewModel : ObservableObject {
    @Published var listings: [Listing] = []
    @Published var isLoading = false // Track loading state
    private let listingRepository: ListingRepository
    
    init(listingRepository: ListingRepository = FirestoreListingRepository()) {
        self.listingRepository = listingRepository
    }
    
    func getAllActiveListings(userId: String?) {
        if(!listings.isEmpty){
            return
        }
        isLoading = true // Show loader
        
        listingRepository.getAllActiveListings(userId: userId) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let listings):
                DispatchQueue.main.async {
                    self?.listings = listings
                }
            case .failure(let error):
                print("Failed to fetch listings: \(error)")
                // Handle error, such as showing an alert to the user
            }
        }
    }
    
    func createListing(bannerImagePath: UIImage?, listing: inout Listing, completion: @escaping (Result<Listing, Error>) -> Void) {
        listing.id = listingRepository.getListingId()
        listing.createdAt = Date()
        listing.updatedAt = Date()
        isLoading = true // Show loader
        listingRepository.setListing(bannerImagePath: bannerImagePath, listing: listing) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let createdListing):
                DispatchQueue.main.async {
                    self?.listings.append(createdListing)
                    completion(.success(createdListing))
                }
            case .failure(let error):
                print("Failed to create listing: \(error)")
                // Handle error, such as showing an alert to the user
                completion(.failure(error)) // Pass back the error
            }
        }
    }
    
    func updateListing(bannerImagePath: UIImage?, listing: inout Listing, completion: @escaping (Result<Listing, Error>) -> Void) {
        listing.updatedAt = Date()
        isLoading = true // Show loader
        listingRepository.setListing(bannerImagePath: bannerImagePath, listing: listing) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let updatedListing):
                DispatchQueue.main.async {
                    // Update the existing listing in the list with the updated one
                    if let index = self?.listings.firstIndex(where: { $0.id == updatedListing.id }) {
                        self?.listings[index] = updatedListing
                    }
                    completion(.success(updatedListing))
                }
            case .failure(let error):
                print("Failed to update listing: \(error)")
                // Handle error, such as showing an alert to the user
                completion(.failure(error)) // Pass back the error
            }
        }
    }


}

