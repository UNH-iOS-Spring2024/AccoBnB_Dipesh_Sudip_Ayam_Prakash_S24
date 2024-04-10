//
//  FirestoreStorageRepository.swift
//  AccoBnB
//
//  Created by AP on 10/04/2024.
//

import Foundation

import FirebaseStorage
import UIKit

class FirestoreStorageRepository : StorageRepository {
    private let storage = Storage.storage()
    
    func uploadImagetoFirebaseStorage(_ image: UIImage,storageName: String, completion: @escaping (Result<String, any Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure("Failed to convert image to data" as! Error))
            return
        }
        
        let storageRef = storage.reference()
        let listingImagesRef = storageRef.child(storageName).child(UUID().uuidString)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        listingImagesRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                completion(.failure(error))
            } else {
                listingImagesRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                    } else if let downloadURL = url {
                        completion(.success(downloadURL.absoluteString))
                    }
                }
            }
        }
    }
    
    func uploadImagetoFirebaseStorageAsync(_ image: UIImage, storageName: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw "Failed to convert image to data" as! Error
        }
        let storageRef = storage.reference()
        let listingImagesRef = storageRef.child(storageName).child(UUID().uuidString)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        do {
            let uploadMetadata = try await listingImagesRef.putDataAsync(imageData, metadata: metadata)
            let downloadURL = try await listingImagesRef.downloadURL()
            print("uploaded", downloadURL.absoluteString)
            return downloadURL.absoluteString
        } catch {
            print("Error while uploading: \(error)")
            throw error
        }
    }
}
