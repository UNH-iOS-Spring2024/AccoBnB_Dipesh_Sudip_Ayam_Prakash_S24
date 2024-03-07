//
//  ListingRepository.swift
//  AccoBnB
//
//  Created by AP on 05/03/2024.
//

import Foundation

protocol ListingRepository {
    func getAllListings(completion: @escaping (Result<[Listing], Error>) -> Void)
}
