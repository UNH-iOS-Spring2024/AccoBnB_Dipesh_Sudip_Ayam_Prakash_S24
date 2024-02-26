//
//  MenuNavigationView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct MenuNavigationView: View {
    var body: some View {
        VStack{
            TabView{
                ListingView()
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                BookingView()
                    .tabItem {
                        Image(systemName: "apps.iphone.badge.plus")
                        Text("Bookings")
                    }
                NotificationView()
                    .tabItem {
                        Image(systemName: "bell")
                        Text("Notification")
                    }
                MyProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
            }
        }
        
    } 
}

#Preview {
    MenuNavigationView()
}
