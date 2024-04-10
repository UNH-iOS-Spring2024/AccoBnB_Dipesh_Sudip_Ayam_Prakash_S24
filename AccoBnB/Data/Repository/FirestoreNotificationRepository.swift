//
//  FirestoreNotificationRepository.swift
//  AccoBnB
//
//  Created by Sudip Thapa on 4/2/24.
//

import Foundation
import FirebaseFirestore

class FirestoreNotificationRepository: NotificationRepository {
    private let db = Firestore.firestore()
    private let notificaitonsCollection = "notifications"
    
    func getNotifications(for userId: String, completion: @escaping (Result<[Notification], Error>) -> Void) {
        db.collection(notificaitonsCollection)
            .whereField("receiverId", isEqualTo: userId)
            .addSnapshotListener{ snapshot, err in
                if let error = err{
                    completion(.failure(error))
                    return
                }
                
                guard let documents = snapshot?.documents else{
                    completion(.success([]))
                    return
                }
                
                let notifications = documents.compactMap { document -> Notification? in
                    let result = Result{
                        try document.data(as: Notification.self)
                    }
                    switch result{
                    case .success(let notification):
                        return notification
                    case .failure(let error):
                        print("Error in decoding notifications \(error)")
                        return nil
                    }
                }
                completion(.success(notifications))
            }
    }
}
