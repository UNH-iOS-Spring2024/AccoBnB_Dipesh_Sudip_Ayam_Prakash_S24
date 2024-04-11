//
//  MapView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 4/5/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State var listings: [Listing] = []
    @EnvironmentObject var listingViewModel: ListingViewModel
    
    @State var updatedListings: [MapAnnotationItems] = []
    
    
    var body: some View {
        
        Map() {
            ForEach(updatedListings, id: \.id) { listing in
                Marker(listing.text, coordinate: listing.coordinate)
            }
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
        .onAppear {
            listings = listingViewModel.listings
            updatedListings = listings.map { listing in
                MapAnnotationItems(text: listing.title, lat: Double(listing.geoLocation!.lat) ?? 0.0, long: Double(listing.geoLocation!.long) ?? 0.0)
                
            }
        }
    }
}

#Preview {
    MapView()
}
