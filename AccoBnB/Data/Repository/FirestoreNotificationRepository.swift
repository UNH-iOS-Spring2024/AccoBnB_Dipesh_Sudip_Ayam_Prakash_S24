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
            .order(by: "createdAt", descending: true)
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
                        print(notification.createdAt!.timeIntervalSinceNow)
                        if (notification.createdAt!.timeIntervalSinceNow > -5){
                            let content = UNMutableNotificationContent()
                            content.title = notification.title
                            content.subtitle = notification.message
                            content.sound = UNNotificationSound.default

                            // show this notification five seconds from now
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                            // choose a random identifier
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                            // add our notification request
                            UNUserNotificationCenter.current().add(request)
                        }
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
