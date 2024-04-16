//
//  BookingRequestView.swift
//  AccoBnB
//
//  Created by AP on 15/04/2024.
//

import SwiftUI
struct BookingRequestView: View {
    @ObservedObject var bookingViewModel: BookingViewModel
    @State private var bookingDetail: Booking?
    @State var bookingId: String // Local state to hold the bookingId
    
    init(bookingViewModel: BookingViewModel, bookingId: String) {
        self.bookingViewModel = bookingViewModel
        self._bookingId = State(initialValue: bookingId)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if var bookingDetail = bookingDetail {
                    // Display the booking details
                    ListingInfoView(listing: bookingDetail.listingInfo)
                    Divider()
                    CustomerInfoView(user: bookingDetail.userInfo)
                    Divider()
                    BookingDetailsView(booking: bookingDetail)
                    Divider()
                    // Accept and Reject Buttons
                    HStack(spacing: 20) {
                        CustomButtonView(buttonText: "Reject", color: "tertiaryColor") {
                            bookingDetail.status = BookingStatus.rejected
                        }
                        .cornerRadius(8)
                        Spacer()
                        CustomButtonView(buttonText: "Approve") {
                            bookingDetail.status = BookingStatus.approved
                            // Handle acceptance action
                        }
                    }
                } else {
                    // Show loading indicator or placeholder
                    ProgressView("Loading Booking detail...")
                }
            }
            .padding()
            .onAppear {
                bookingViewModel.getBookingById(bookingId: bookingId){result in
                    switch result {
                    case .success(let booking):
                        print("success",booking as Any)
                        self.bookingDetail = booking
                    case .failure(let error):
                        print("Error fetching booking details: \(error)")
                    }
                }
             
            }
        }
    }
}

// Listing Info
struct ListingInfoView: View {
    var listing: Listing?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Listing Information")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
            
            // Display listing information if available
            if let listing = listing {
                VStack(spacing: 5) {
                    HStack {
                        Text("Title")
                            .fontWeight(.bold)
                        Spacer()
                        Text(listing.title)
                            .multilineTextAlignment(.trailing)
                    }
                    
                }
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Location")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(listing.address.addressLine1), \(listing.address.city), \(listing.address.country), \(listing.address.zipCode)")
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                VStack(spacing: 5) {
                    HStack {
                        Text("Type")
                            .fontWeight(.bold)
                        Spacer()
                        Text(listing.type.rawValue)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }
}


// Customer Information
struct CustomerInfoView: View {
    var user: User?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Customer Information")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
            
            // Display user information if available
            if let user = user {
                VStack(spacing: 5) {
                    HStack{
                        
                        Text("Name")
                            .fontWeight(.bold)
                        Spacer()
                        Text("\(user.firstName) \(user.lastName)")
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                VStack(spacing: 5) {
                    HStack{
                        
                        Text("Phone Number")
                            .fontWeight(.bold)
                        Spacer()
                        Text(user.phone.isEmpty ? "NA" : user.phone)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                VStack(spacing: 5) {
                    HStack{
                        Text("Email")
                            .fontWeight(.bold)
                        Spacer()
                        Text(user.email)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
    }
}

// Booking Details
struct BookingDetailsView: View {
    var booking: Booking
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Booking Information")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
            VStack(spacing: 5) {
                // Requested Date
                HStack {
                    Text("Requested on")
                        .fontWeight(.bold)
                    Spacer()
                    if let createdAt = booking.createdAt {
                        Text(createdAt.formattedDateToString())
                    } else {
                        Text("N/A")
                            .foregroundColor(.gray)
                    }
                }
            }
            VStack(spacing: 5) {
                // Amount
                HStack {
                    Text("Amount")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(booking.totalAmount)")
                }
            }
        }
        HStack{
            Text("Booking Note")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(booking.bookingNote)
                .frame(maxWidth: .infinity, alignment: .bottomTrailing)
            
        }
    }
}


struct BookingRequestView_Previews: PreviewProvider {
    static var previews: some View {
        let booking = Booking.defaultBooking
        let authVm = AuthViewModel()
        authVm.currentUser = User.defaultHostUser
        let bookingVm = BookingViewModel(authViewModel: authVm)
        return BookingRequestView(bookingViewModel: bookingVm, bookingId:booking.id!)
    }
}
