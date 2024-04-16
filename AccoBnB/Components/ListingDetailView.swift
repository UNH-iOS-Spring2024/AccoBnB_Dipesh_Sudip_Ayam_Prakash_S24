//
//  ListingDetailView.swift
//  AccoBnB
//
//  Created by AP on 12/03/2024.
//

import SwiftUI
import MapKit

struct ListingDetailView: View {
    @State var listingDetail: Listing
    //Declaring region for map view ,can't initialize lat and long here as self is available in only init() method
    @State var region: MKCoordinateRegion
    // Use a binding to control the presentation of BookingRequestView
    @State var isBookingRequestViewPresented: Bool = false
    @EnvironmentObject var bookingViewModel: BookingViewModel
    @State var isAlreadyBooked : Bool = false
    @State var isAdminView : Bool = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // using init method to initialize the region variable with the passed parameter.
    init(listingDetail: Listing) {
        // initializing passed parameter to state variable.
        self._listingDetail = State(initialValue: listingDetail)
        
        // Initialize region here where 'self' is available
        let center = CLLocationCoordinate2D(
            latitude: Double(listingDetail.geoLocation?.lat ?? "0.0")!,
            longitude: Double(listingDetail.geoLocation?.long ?? "0.0")!
        )
        // initializing state variable "region" with coordinates
        self._region = State(initialValue: MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)))
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY"
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                List {
                    // ".listRowInsets()" will remove the default padding from List{}
                    ListingCardView(listingDetail: listingDetail)
                        .listRowInsets(EdgeInsets())
                    
                    Section("Description"){
                        Text(listingDetail.description)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Section("Reviews"){
                        ScrollView(.horizontal){
                            HStack {
                                if listingDetail.reviews.isEmpty{
                                    Text("No reviews yet.")
                                } else {
                                    ForEach(listingDetail.reviews) { review in
                                        let formattedDate = review.date!.formattedDateToString()
                                        ReviewCardView(ratingValue: review.rating, date: formattedDate, reviewerName: review.reviewerName, comment: review.comment)
                                            .frame(width: 250)
                                            .containerRelativeFrame(.horizontal)
                                    }
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                    }
                    
                    Section("Location"){
                        // interaction mode is used to restrict user interactions
                        Map() {
                            Marker("", coordinate: region.center)
                        }
                        .listRowInsets(EdgeInsets())
                        .frame(width: 400, height: 200)
                    }
                }
                .onAppear{
                    isAlreadyBooked  = self.bookingViewModel.bookings.contains {
                        $0.listingId == listingDetail.id
                    }
                    if let currentUser = authViewModel.currentUser {
                        isAlreadyBooked = currentUser.role == UserRole.host || isAlreadyBooked
                    }
                    
                }
                CustomButtonView(buttonText: "Book Now") {
                    isBookingRequestViewPresented = true // Set the binding variable to true to present BookingRequestView
                }
                .disabled(isAlreadyBooked)
                
            }
            
            if isBookingRequestViewPresented {
                Color.black.opacity(0.5)
                    .onTapGesture {
                        isBookingRequestViewPresented = false // Close BookingRequestView on tap outside
                    }
                VStack {
                    Spacer()
                    BottomSheetView(isPresented: $isBookingRequestViewPresented, viewTitle: "Booking Request", showAlert: true, alertTitle: "Confirm Booking?", alertMessage: "Please click on confirm button to request for booking.") { bookingNote, _ in
                        bookingViewModel.createBooking(userId: authViewModel.currentUser!.id, listingId: listingDetail.id, bookingNote: bookingNote) { result in
                            switch result {
                            case .success(_):
                                isBookingRequestViewPresented = false
                                isAlreadyBooked = true
                            case .failure(let error):
                                print("Failed to create booking: \(error)")
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                }
                
            }
        }
    }
}

struct ListingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let newListing = Listing.defaultListing
        let authVm = AuthViewModel()
        authVm.currentUser = User.defaultGuestUser
        let bookingVm = BookingViewModel()
        return ListingDetailView(listingDetail: newListing)
            .environmentObject(bookingVm)
            .environmentObject(authVm)
    }
}
