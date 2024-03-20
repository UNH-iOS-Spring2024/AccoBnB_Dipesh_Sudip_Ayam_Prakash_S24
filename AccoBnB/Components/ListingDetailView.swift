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
        self._region = State(initialValue: MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
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
                                ForEach(listingDetail.reviews){review in
                                    ReviewCardView(ratingValue: review.rating, date: String(review.date.prefix(10))+","+String(review.date.suffix(5)), reviewerName: "Anonymous", comment: review.comment)
                                        .frame(width: 280)
                                        .containerRelativeFrame(.horizontal)
                                }
                            }
                        }
                        .scrollTargetBehavior(.paging)
                    }
                    
                    Section("Location"){
                        // interaction mode is used to restrict user interactions
                        Map(coordinateRegion: $region, interactionModes: [.pan, .zoom])
                            .listRowInsets(EdgeInsets())
                            .frame(width: 400, height: 200)
                    }
                }
                CustomButtonView(buttonText: "Book Now") {
                    isBookingRequestViewPresented = true // Set the binding variable to true to present BookingRequestView
                }
            }
            
            if isBookingRequestViewPresented {
                Color.black.opacity(0.5)
                    .onTapGesture {
                    isBookingRequestViewPresented = false // Close BookingRequestView on tap outside
                }
                VStack {
                    Spacer()
                    BookingRequestView(isPresented: $isBookingRequestViewPresented)
                        .background(Color.white)
                        .cornerRadius(10)
                }
            }
        }
    }
}

#Preview {
    let newListing = Listing.defaultListing
       return ListingDetailView(listingDetail: newListing)

}
