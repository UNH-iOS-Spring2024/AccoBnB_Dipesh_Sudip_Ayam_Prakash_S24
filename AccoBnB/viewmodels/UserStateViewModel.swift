//
//  UserStateViewModel.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/7/24.
//

import Foundation
class UserStateViewModel: ObservableObject{
    @Published var isLoggedIn: Bool = true
    
    func signIn(){
        self.isLoggedIn = true
    }
    
    func signOut(){
        self.isLoggedIn = false
    }
}
