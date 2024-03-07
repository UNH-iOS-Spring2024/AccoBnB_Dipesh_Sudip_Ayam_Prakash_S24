//
//  ContentView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            if userStateVM.isLoggedIn == true{
                MenuNavigationView()
            }else{
                LoginView(email: "", password: "")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
