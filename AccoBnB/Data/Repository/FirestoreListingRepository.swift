//
//  FirebaseListingRepository.swift
//  AccoBnB
//
//  Created by AP on 05/03/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class FirestoreListingRepository: ListingRepository {
    private let db = Firestore.firestore()
    private let listingsCollection = "listings" // Firestore collection name
    private let reviewsCollection = "reviews"
    private let storage = Storage.storage()
    
    func getListingId() -> String {
        return db.collection(listingsCollection).document().documentID
    }
    
    func getAllActiveListings(completion: @escaping (Result<[Listing], Error>) -> Void) {
        db.collection(listingsCollection).order(by: "createdAt", descending: true).addSnapshotListener { snapshot, error in
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
                        self.getReviewsByListingId(for: listing.id){result in
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
    
    private func getReviewsByListingId(for listingId: String, completion: @escaping (Result<[Review], Error>) -> Void){
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
    
    func createListing(bannerImagePath: UIImage?, listing: Listing, completion: @escaping (Result<Listing, Error>) -> Void) {
        var updatedListing = listing
        
        // Check if bannerImagePath is provided
        if let bannerImagePath = bannerImagePath {
            // Upload the image data to Firebase Storage
            let storageRepo = FirestoreStorageRepository()
            storageRepo.uploadImagetoFirebaseStorage(bannerImagePath,storageName: "listings"){ result in
                switch result {
                case .success(let imageURL):
                    // If successful, update the listing's bannerImage with the imageURL
                    updatedListing.bannerImage = imageURL
                    // Add the updated listing to Firestore
                    self.addListingToFirestore(listing: updatedListing, completion: completion)
                case .failure(let error):
                    // If upload fails, pass the error to the completion handler
                    completion(.failure(error))
                }
            }
        } else {
            // If no banner image provided, directly add the listing to Firestore
            addListingToFirestore(listing: updatedListing, completion: completion)
        }
    }
    
    
    
    
    
    private func addListingToFirestore(listing: Listing, completion: @escaping (Result<Listing, Error>) -> Void) {
        do {
            try db.collection(listingsCollection).document(listing.id).setData(Firestore.Encoder().encode(listing)) { error in
                if let error = error {
                    print("Error while adding listing: \(error)")
                    completion(.failure(error))
                } else {
                    completion(.success(listing))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func getListingById(listingId: String, completion: @escaping (Result<Listing?, Error>) -> Void) {
        db.collection(listingsCollection).document(listingId).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = snapshot?.data() {
                do {
                    let listing = try Firestore.Decoder().decode(Listing.self, from: data)
                    completion(.success(listing))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.success(nil))
            }
        }
    }
    
//    private func uploadListingImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
//        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
//            completion(.failure("Failed to convert image to data" as! Error))
//            return
//        }
//        
//        let storageRef = storage.reference()
//        let listingImagesRef = storageRef.child("listings").child(UUID().uuidString)
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//        listingImagesRef.putData(imageData, metadata: metadata) { metadata, error in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                listingImagesRef.downloadURL { url, error in
//                    if let error = error {
//                        completion(.failure(error))
//                    } else if let downloadURL = url {
//                        completion(.success(downloadURL.absoluteString))
//                    }
//                }
//            }
//        }
//    }
    
}
