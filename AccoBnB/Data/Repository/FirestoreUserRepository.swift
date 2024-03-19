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
    private let userId = "HTBPM53yGJalG6JpB4wuQmVYKGx1"
    
    func getUserDetails(completion: @escaping (Result<[User], Error>) -> Void) {
//        db.collection(userCollection).document(userId).getDocument(){ (snapshot, error) in
//            
//            if let error = error{
//                completion(.failure(error))
//                return
//            }
//            
//            guard let documents = snapshot?.document else{
//                completion(.success([]))
//                return
//            }
//        }
    }
}
