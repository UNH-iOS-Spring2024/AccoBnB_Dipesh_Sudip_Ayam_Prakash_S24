//
//  FirestoreUserRepository.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/18/24.
//

import Foundation
import FirebaseFirestore

class FirestoreUserRepository: UserRepository{
    private var authViewModel: AuthViewModel
    
    private let db = Firestore.firestore()
    private let userCollection = "users"
    
    init(authViewModel: AuthViewModel = AuthViewModel()) {
        self.authViewModel = authViewModel
    }
        
    
    func getUserDetails(completion: @escaping (Result<User, Error>) -> Void) {
        
        Task{
            do{
                await db.collection(userCollection).document(authViewModel.userSession!.uid).getDocument(){ (document, error) in
                    
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
            } catch {
                completion(.failure(error))
            }
        }
    }
}
