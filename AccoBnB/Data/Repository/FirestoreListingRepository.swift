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
    
    func getAllActiveListings(userId: String?, completion: @escaping (Result<[Listing], Error>) -> Void) {
        var query = db.collection(listingsCollection)
            .order(by: "createdAt", descending: true)
        
        if let userId = userId {
            // If userId is provided, filter listings by hostId
            query = query.whereField("hostId", isEqualTo: userId)
        }
        query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            var listings: [Listing] = []
            let dispatchGroup = DispatchGroup()
            
            for document in documents {
              dispatchGroup.enter()

              let result = Result {
                try document.data(as: Listing.self)
              }

              switch result {
              case .success(let listing):
                var mutableListing = listing
                self.getReviewsByListingId(for: mutableListing.id) { result in
                  switch result {
                  case .success(let reviews):
                    mutableListing.reviews = reviews
                    mutableListing.rating = reviews.count > 0 ? (reviews.map { $0.rating }.reduce(0, +)) / Float(reviews.count) : 0.0
                    listings.append(mutableListing)
                  case .failure(let error):
                    print("Error in fetching reviews \(error)")
                  }
                  dispatchGroup.leave()
                }
              case .failure(let error):
                print("Error decoding listing: \(error)")
                dispatchGroup.leave()
              }
            }
            dispatchGroup.notify(queue: .main) {
                completion(.success(listings))
            }
        }
    }
    
    func getAllActiveListings(completion: @escaping (Result<[Listing], Error>) -> Void) {
      let query = db.collection(listingsCollection)
          .whereField("isPublished", isEqualTo: true)
          .order(by: "createdAt", descending: true)

      query.addSnapshotListener { snapshot, error in
        if let error = error {
          completion(.failure(error))
          return
        }

        guard let documents = snapshot?.documents else {
          completion(.success([]))
          return
        }

        var listings: [Listing] = []
        let dispatchGroup = DispatchGroup()

        for document in documents {
          dispatchGroup.enter()

          let result = Result {
            try document.data(as: Listing.self)
          }

          switch result {
          case .success(let listing):
            var mutableListing = listing
            self.getReviewsByListingId(for: mutableListing.id) { result in
              switch result {
              case .success(let reviews):
                mutableListing.reviews = reviews
                mutableListing.rating = reviews.count > 0 ? (reviews.map { $0.rating }.reduce(0, +)) / Float(reviews.count) : 0.0
                listings.append(mutableListing)
              case .failure(let error):
                print("Error in fetching reviews \(error)")
              }
              dispatchGroup.leave()
            }
          case .failure(let error):
            print("Error decoding listing: \(error)")
            dispatchGroup.leave()
          }
        }

        dispatchGroup.notify(queue: .main) {
          completion(.success(listings))
        }
      }
    }
    
    private func getReviewsByListingId(for listingId: String, completion: @escaping (Result<[Review], Error>) -> Void){
        db.collection(reviewsCollection)
            .whereField("listingId",isEqualTo: listingId)
            .getDocuments{ snapshot, err in
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
    
    func setListing(bannerImagePath: UIImage?, listing: Listing, completion: @escaping (Result<Listing, Error>) -> Void) {
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
                    self.setListingToFirestore(listing: updatedListing, completion: completion)
                case .failure(let error):
                    // If upload fails, pass the error to the completion handler
                    completion(.failure(error))
                }
            }
        } else {
            // If no banner image provided, directly add the listing to Firestore
            setListingToFirestore(listing: updatedListing, completion: completion)
        }
    }
    
    
    
    
    
    private func setListingToFirestore(listing: Listing, completion: @escaping (Result<Listing, Error>) -> Void) {
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
