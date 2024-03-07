//
//  SplashScreenView.swift
//  AccoBnB
//
//  Created by AP on 25/02/2024.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isSplashScreenActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var isLoggedIn = false // change this to check if user authenticated from firebase
    var body: some View {
        if isSplashScreenActive {
            if isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        } else {
            VStack {
                VStack {
                    Image("ic_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Text("Your Accomodation, Your Way")
                        .font(.system(size: 28))
                        .foregroundColor(Color("primaryColor"))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.5)){
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.4){ // change this timing to value after data from db is loaded.
                    withAnimation{
                        self.isSplashScreenActive = true
                    }
                }
            }
        }
        
    }
}

#Preview {
    SplashScreenView()
}
