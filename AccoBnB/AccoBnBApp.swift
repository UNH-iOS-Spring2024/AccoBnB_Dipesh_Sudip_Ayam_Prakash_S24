//
//  AccoBnBApp.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications
import SwiftUI

@main
struct AccoBnBApp: App {
    @StateObject var authViewModel = AuthViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
        .environmentObject(authViewModel)
    }
}
