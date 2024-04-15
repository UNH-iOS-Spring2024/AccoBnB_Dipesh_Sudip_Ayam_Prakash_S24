//
//  UserProfileViewModel.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/18/24.
//

import Foundation
import UIKit

final class UserProfileViewModel: ObservableObject{
    @Published var userDetail: User = User()
    @Published var isLoading = false
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository = FirestoreUserRepository()) {
        self.userRepository = userRepository
    }
    
    func getUserDetails(userId: String){
        isLoading = true
        userRepository.getUserDetails(userId: userId) { result in
            self.isLoading = false
            switch(result){
            case .success(let user):
                DispatchQueue.main.async {
                    self.userDetail = user
                }
            case .failure(let error):
                print("Failed to fetch user detail: \(error)")
            }
        }
    }
    
    func updateUserDetail(userImage: UIImage?, userDetail: User) async{
        isLoading = true
        do {
            try await userRepository.updateUserDetail(userImage: userImage,userDetail: userDetail)
            isLoading = false
        } catch {
            print("DEBUG: Unable to update user detail with error \(error.localizedDescription)")
        }
    }
}
