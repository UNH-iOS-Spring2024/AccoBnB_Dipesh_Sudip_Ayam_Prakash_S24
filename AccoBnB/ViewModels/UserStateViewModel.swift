//
//  UserStateModel.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/27/24.
//

import Foundation

class UserStateViewModel: ObservableObject{
    @Published var isLoggedIn: Bool = false
    
    func signIn(){
        self.isLoggedIn = true
    }
    
    func signOut(){
        self.isLoggedIn = false
    }
}
