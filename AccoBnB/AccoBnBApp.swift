//
//  AccoBnBApp.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI
import Firebase

@main
struct AccoBnBApp: App {
    //@StateObject var userStateVM = UserStateViewModel()
    init(){
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
