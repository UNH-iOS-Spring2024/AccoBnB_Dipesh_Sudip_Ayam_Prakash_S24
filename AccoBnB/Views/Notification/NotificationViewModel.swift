//
//  NotificationViewModel.swift
//  AccoBnB
//
//  Created by Sudip Thapa on 4/2/24.
//

import Foundation

final class NotificationViewModel : ObservableObject {
    @Published var notifications: [Notification] = []
    @Published var isLoading = false // Track loading state
    private let notificationRepository: NotificationRepository
    
    init(notificationRepository: NotificationRepository = FirestoreNotificationRepository()) {
        self.notificationRepository = notificationRepository
    }
    
    func getNotifications(userId: String) {
        isLoading = true // Show loader
        notificationRepository.getNotifications(for: userId) { [weak self] result in
            self?.isLoading = false // Hide loader after operation completes
            switch result {
            case .success(let notifications):
                DispatchQueue.main.async {
                    self?.notifications = notifications
                }
            case .failure(let error):
                print("Failed to fetch listings: \(error)")
            }
        }
    }
}
