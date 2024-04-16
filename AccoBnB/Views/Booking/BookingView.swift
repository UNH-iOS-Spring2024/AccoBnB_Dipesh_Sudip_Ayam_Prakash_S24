//
//  BookingView.swift
//  AccoBnB
//
//  Created by AP on 23/03/2024.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @EnvironmentObject var authViewModel: AuthViewModel

    
    var body: some View {
        NavigationSplitView {
            ScrollView {
                VStack(spacing: 10) {
                    if(bookingViewModel.bookings.isEmpty){
                        Text("No Bookings Available")
                    } else {
                        ForEach(bookingViewModel.bookings, id: \.id) { booking in
                            NavigationLink(destination: BookingSummary(bookingDetail: booking).navigationTitle("Summary")){
                                ListingCardView(listingDetail: booking.listingInfo ?? Listing.defaultListing)
                                    .padding(.horizontal)
                            }
                            .navigationTitle("Bookings")
                        }

                    }
                }.onAppear{
                    if(authViewModel.userSession != nil){
                        bookingViewModel.getUserBooking(userId: authViewModel.userSession!.uid)
                    }
                }
            }
            .padding(.vertical)
        } detail: {
            Text("Show more")
        }
        
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.defaultGuestUser
        let bookingViewModel = BookingViewModel()
        return BookingView()
            .environmentObject(authViewModel)
            .environmentObject(bookingViewModel)
    }
}
