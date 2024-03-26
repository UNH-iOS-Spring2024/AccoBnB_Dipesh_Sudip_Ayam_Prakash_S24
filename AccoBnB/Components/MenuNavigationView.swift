//
//  MenuNavigationView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct MenuNavigationView: View {
    @StateObject var bookingViewModel = BookingViewModel(text:"menunavview")
    @ObservedObject var listingViewModel = ListingViewModel()
    
    var body: some View {
        VStack{
            TabView{
                ListingView()
                    .environmentObject(listingViewModel)
                    .environmentObject(bookingViewModel)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Home")
                    }
                BookingView()
                    .environmentObject(bookingViewModel)
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

struct MenuNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        MenuNavigationView()
    }
}
