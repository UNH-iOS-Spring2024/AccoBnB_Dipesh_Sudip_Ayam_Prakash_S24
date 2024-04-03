//
//  NotificationRepository.swift
//  AccoBnB
//
//  Created by Sudip Thapa on 4/2/24.
//

import Foundation

protocol NotificationRepository {
    func getNotifications(for userId: String, completion: @escaping (Result<[Notification], Error>) -> Void)
}

