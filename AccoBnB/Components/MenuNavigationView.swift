//
//  MenuNavigationView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct MenuNavigationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject var bookingViewModel: BookingViewModel
    @ObservedObject var listingViewModel = ListingViewModel()
    @StateObject var reviewViewModel = ReviewViewModel()
    @StateObject var notificationViewModel = NotificationViewModel()
    
    init(authViewModel: AuthViewModel) {
        _bookingViewModel = StateObject(wrappedValue: BookingViewModel(authViewModel: authViewModel))
    }
    
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
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                    .environmentObject(listingViewModel)
                if authViewModel.currentUser?.role == UserRole.guest {
                    BookingView()
                        .environmentObject(bookingViewModel)
                        .environmentObject(reviewViewModel)
                        .tabItem {
                            Image(systemName: "apps.iphone.badge.plus")
                            Text("Bookings")
                        }
                } else {
                    ManageListingView()
                        .environmentObject(listingViewModel)
                        .environmentObject(bookingViewModel)
                        .tabItem {
                            Image(systemName: "apps.iphone.badge.plus")
                            Text("Manage Listings")
                        }
                }
                NotificationView()
                    .environmentObject(notificationViewModel)
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
        let authViewModel = AuthViewModel() // Create an instance of AuthViewModel
        MenuNavigationView(authViewModel: authViewModel) // Pass authViewModel to MenuNavigationView
    }
}
