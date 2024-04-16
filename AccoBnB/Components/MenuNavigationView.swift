//
//  MenuNavigationView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct MenuNavigationView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @ObservedObject var bookingViewModel = BookingViewModel()
    @ObservedObject var listingViewModel = ListingViewModel()
    @ObservedObject var reviewViewModel = ReviewViewModel()
    @ObservedObject var notificationViewModel = NotificationViewModel()
    
    
    var body: some View {
        VStack{
            TabView{
                ListingView()
                    .environmentObject(authViewModel)
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
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.defaultGuestUser
        return MenuNavigationView().environmentObject(authViewModel)
    }
}
