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
            if $authViewModel.userSession != nil{
                    MenuNavigationView(authViewModel: authViewModel)
            }else{
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
