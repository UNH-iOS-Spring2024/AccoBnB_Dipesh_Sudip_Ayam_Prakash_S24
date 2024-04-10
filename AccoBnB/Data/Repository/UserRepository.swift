//
//  UserRepository.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/18/24.
//

import Foundation
import UIKit

protocol UserRepository{
    func getUserDetails(userId: String, completion: @escaping (Result<User, Error>) -> Void)
    func updateUserDetail(userImage: UIImage?,userDetail: User) async throws
}
