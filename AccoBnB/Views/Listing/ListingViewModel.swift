//
//  ListingViewModel.swift
//  AccoBnB
//
//  Created by AP on 05/03/2024.
//

import Foundation

final class ListingViewModel : ObservableObject {
    @Published var listings: [Listing] = []
    @Published var isLoading = false // Track loading state
    private let listingRepository: ListingRepository
    
    init(listingRepository: ListingRepository = FirestoreListingRepository()) {
        self.listingRepository = listingRepository
    }
    
    func getAllListings() {
        isLoading = true // Show loader
        listingRepository.getAllListings { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let listings):
                DispatchQueue.main.async {
                    print("Got all listing")
                    self?.listings = listings
                }
            case .failure(let error):
                print("Failed to fetch listings: \(error)")
                // Handle error, such as showing an alert to the user
            }
        }
    }
}

