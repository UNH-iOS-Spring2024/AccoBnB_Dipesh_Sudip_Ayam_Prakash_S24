//
//  UserProfileViewModel.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/18/24.
//

import Foundation

final class UserProfileViewModel: ObservableObject{
    @Published var userDetail: User = User()
    @Published var isLoading = false
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository = FirestoreUserRepository()) {
        self.userRepository = userRepository
    }
    
    func getUserDetails(){
        isLoading = true
        userRepository.getUserDetails { result in
            self.isLoading = false
            switch(result){
            case .success(let user):
                DispatchQueue.main.async {
                    self.userDetail = user
                }
            print("user data: \(user)")
            case .failure(let error):
                print("Failed to fetch user detail: \(error)")
            }
        }
    }
}
