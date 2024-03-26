//
//  BookingView.swift
//  AccoBnB
//
//  Created by AP on 23/03/2024.
//

import SwiftUI

struct BookingView: View {
    @EnvironmentObject var bookingViewModel: BookingViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(bookingViewModel.bookings, id: \.id) { booking in
                    ListingCardView(listingDetail: booking.listingInfo ?? Listing.defaultListing)
                        .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        let authViewModel = AuthViewModel() // Create an instance of AuthViewModel
        let bookingViewModel = BookingViewModel(authViewModel: authViewModel) // Create a mock BookingViewModel
        BookingView()
            .environmentObject(bookingViewModel) // Provide the mock BookingViewModel for preview
    }
}
