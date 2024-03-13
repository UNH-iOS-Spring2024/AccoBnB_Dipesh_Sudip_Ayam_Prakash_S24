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
                    //TODO: Need to add this functionality.
                    Text("TODO: Need to add this functionality.")
                }
                
                Section("Location"){
                    // interaction mode is used to restrict user interactions
                    Map(coordinateRegion: $region, interactionModes: [.pan, .zoom])
                        .listRowInsets(EdgeInsets())
                        .frame(width: 400, height: 200)
                }
            }
            
            CustomButtonView(buttonText: "Book Now"){
                print("Book Now button clicked.")
            }
        }
    }
}

#Preview {
    let newListing = Listing.defaultListing
    return ListingDetailView(listingDetail: newListing)
}
