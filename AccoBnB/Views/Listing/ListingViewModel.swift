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
    @Published var hostListings: [Listing] = []
    @Published var isLoading = false // Track loading state
    // variable that stores the user input in search box of listing view screen
    @Published var searchText = ""
    // this computed property filters out all the listing based on the search text
    var filteredListings: [Listing] {
        // if user doesn't type anything is search box then return all the listings to filteredListings
        guard !searchText.isEmpty else {
            return listings
        }
        // if user types in search box then check the listing title as well as address to match the search text
        // and filter out those matching listings.
        return listings.filter { listing in
            listing.title.localizedCaseInsensitiveContains(searchText) || listing.address.addressLine1.localizedCaseInsensitiveContains(searchText) ||
            listing.address.addressLine2.localizedCaseInsensitiveContains(searchText) ||
            listing.address.city.localizedCaseInsensitiveContains(searchText) ||
            listing.address.country.localizedCaseInsensitiveContains(searchText) ||
            listing.address.zipCode.localizedCaseInsensitiveContains(searchText)
        }
    }
    private let listingRepository: ListingRepository
    
    init(listingRepository: ListingRepository = FirestoreListingRepository()) {
        self.listingRepository = listingRepository
    }
    
    func getAllActiveListings() {
        isLoading = true // Show loader
        
        listingRepository.getAllActiveListings() { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let listings):
                DispatchQueue.main.async {
                    print("listingsLoaded")
                    self?.listings = listings
                }
            case .failure(let error):
                print("Failed to fetch listings: \(error)")
                // Handle error, such as showing an alert to the user
            }
        }
    }
    
    func getAllActiveListings(userId: String?) {
        isLoading = true // Show loader
        
        listingRepository.getAllActiveListings(userId: userId) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let listings):
                DispatchQueue.main.async {
                    self?.hostListings = listings
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

