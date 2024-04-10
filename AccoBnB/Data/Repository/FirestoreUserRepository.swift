//
//  FirestoreUserRepository.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/18/24.
//

import Foundation
import FirebaseFirestore

class FirestoreUserRepository: UserRepository{
    
    private let db = Firestore.firestore()
    private let userCollection = "users"
    
    func getUserDetails(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        Task{
            do{
                db.collection(userCollection).document(userId).getDocument(){ (document, error) in
                    
                    if let error = error{
                        completion(.failure(error))
                        return
                    }
                    
                    guard let document = document, document.exists else {
                        let error = NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "User document not found"])
                        completion(.failure(error))
                        return
                    }
                    
                    let result = Result{
                        try document.data(as: User.self)
                    }
                    switch(result){
                    case .success(let user):
                        completion(.success(user))
                    case .failure(let error):
                        print("error in decoding user \(error)")
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateUserDetail(userImage: UIImage?, userDetail: User) async throws {
      var updatedUser = userDetail
      let userId = updatedUser.id
      if let imageToUpload = userImage {
        let storageRepo = FirestoreStorageRepository()
        let imageURL = try await storageRepo.uploadImagetoFirebaseStorageAsync(imageToUpload, storageName: "profiles")
        updatedUser.profileImage = imageURL
      }
      let encodedUserDetail = try Firestore.Encoder().encode(updatedUser)
      try await Firestore.firestore().collection(userCollection).document(userId).setData(encodedUserDetail)
    }
    
}
