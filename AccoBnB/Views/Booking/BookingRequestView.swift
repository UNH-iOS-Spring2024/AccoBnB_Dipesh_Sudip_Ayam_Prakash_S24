//
//  BookingRequestView.swift
//  AccoBnB
//
//  Created by AP on 15/04/2024.
//

import SwiftUI
struct BookingRequestView: View {
    @ObservedObject var bookingViewModel = BookingViewModel()
    @State private var bookingDetail: Booking?
    @State var bookingId: String
    @Environment(\.dismiss) var dismiss
    
    init(bookingId: String) {
        self._bookingId = State(initialValue: bookingId)
    }
    
    func updateBookingStatus(to status: BookingStatus) {
        if var bookingDetail = bookingDetail {
            bookingDetail.status = status
            bookingViewModel.updateBooking(booking: bookingDetail) { result in
                switch result {
                case .success:
                    dismiss()
                case .failure(let error):
                    print("Error updating booking status: \(error)")
                }
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                if let bookingDetail = bookingDetail {
                    ListingInfoView(listing: bookingDetail.listingInfo)
                    Divider()
                    CustomerInfoView(user: bookingDetail.userInfo)
                    Divider()
                    BookingDetailsView(booking: bookingDetail)
                    Divider()
                    if bookingDetail.status == .pending {
                        HStack(spacing: 20) {
                            CustomButtonView(buttonText: "Reject", color: "tertiaryColor") {
                                updateBookingStatus(to: .rejected)
                            }
                            .cornerRadius(8)
                            Spacer()
                            CustomButtonView(buttonText: "Approve") {
                                updateBookingStatus(to: .approved)
                            }
                        }
                    } else {
                        VStack(spacing: 5) {
                            HStack {
                                Text("Booking Status")
                                    .fontWeight(.bold)
                                Spacer()
                                Text(bookingDetail.status.rawValue)
                                    .multilineTextAlignment(.trailing)
                            }
                            
                        }
                    }
                } else {
                    ProgressView("Loading Booking detail...")
                }
            }
            .padding()
            .onAppear {
                bookingViewModel.getBookingById(bookingId: bookingId){result in
                    switch result {
                    case .success(let booking):
                        self.bookingDetail = booking
                    case .failure(let error):
                        print("Error fetching booking details: \(error)")
                    }
                }
                
            }
        }
    }
}

struct ListingInfoView: View {
    var listing: Listing?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Listing Information")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
            
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


struct CustomerInfoView: View {
    var user: User?
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Customer Information")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.bottom, 15)
            
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
                HStack {
                    Text("Booked on:")
                        .fontWeight(.bold)
                    Spacer()
                    Text(booking.createdAt.formattedDateTimeToString())
                }
            }
            VStack(spacing: 5) {
                HStack {
                    Text("Total Amount:")
                        .fontWeight(.bold)
                    Spacer()
                    Text(String(format: "$%.2f", booking.totalAmount))
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
        return BookingRequestView(bookingId:booking.id!)
    }
}
