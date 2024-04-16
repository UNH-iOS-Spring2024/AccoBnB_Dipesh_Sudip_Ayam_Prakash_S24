//
//  ContentView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
           if authViewModel.userSession != nil && authViewModel.currentUser != nil {
               MenuNavigationView(authViewModel: authViewModel)
           } else {
               LoginView()
           }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.defaultGuestUser
        return ContentView().environmentObject(authViewModel)
    }
}
