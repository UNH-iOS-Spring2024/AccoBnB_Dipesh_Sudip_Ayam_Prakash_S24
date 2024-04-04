//
//  AddListingView.swift
//  AccoBnB
//
//  Created by AP on 29/03/2024.
//

import SwiftUI
import MapKit


struct AddListingView: View {
    @State private var listingDetail = Listing()
    @State private var selectedLocation: MKLocalSearchCompletion?
    @State private var searchResultsAvailable = false // Track if search results are available
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                TextField("Title", text: $listingDetail.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $listingDetail.description)
                    .frame(minHeight: 100)
                    .border(Color.gray, width: 1)
                
                Picker("Listing Type", selection: $listingDetail.type) {
                    Text("Rental").tag(ListingType.rental)
                    Text("Temporary").tag(ListingType.temporary)
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    if listingDetail.type == ListingType.rental{
                        Text("Available Rooms")
                        Spacer()
                        TextField("Rooms", text: Binding(
                            get: { String(listingDetail.availableRooms) },
                            set: { if let value = Int($0) { listingDetail.availableRooms = value } }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    }else {
                        Text("Guest Count")
                        Spacer()
                        TextField("Guests", text: Binding(
                            get: { String(listingDetail.guestCount) },
                            set: { if let value = Int($0) { listingDetail.availableRooms = value } }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    }
                    
                }
                
                HStack {
                    if listingDetail.type == ListingType.rental{
                        Text("Price")
                        Spacer()
                        TextField("Price", text: Binding(
                            get: { String(listingDetail.monthlyPrice) },
                            set: { if let value = Float($0) { listingDetail.monthlyPrice = value } }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        Text("/ month")
                    }else {
                        Text("Price")
                        Spacer()
                        TextField("Price", text: Binding(
                            get: { String(listingDetail.dailyPrice) },
                            set: { if let value = Float($0) { listingDetail.dailyPrice = value } }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        Text("/ day")
                    }
                    
                }
                // Add image picker here
                // Add ammenities
                Text("Amenities")
                    .font(.title2)
                    .fontWeight(.bold)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(Amenity.allCases, id: \.self) { amenity in
                            AmenityChipView(amenity: amenity, selectedAmenities: $listingDetail.amenities)
                        }
                    }
                    .padding(.vertical, 8)
                }
                AddressSearchBarView { location in
                    self.selectedLocation = location
                }.frame(height: 300)
                
                
                TextField("Address", text: $listingDetail.address.addressLine1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Apt, Suite, etc", text: $listingDetail.address.addressLine2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    TextField("City", text: $listingDetail.address.city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Country", text: $listingDetail.address.country)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("ZipCode", text: $listingDetail.address.zipCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                CustomButtonView(buttonText: "Submit"){
                    if let location = selectedLocation {
                        reverseGeocode(location: location)
                    }
                    print("New Listing:", listingDetail)
                }
            }
            .padding()
//            .overlay(
//                // 1. Overlay TestSearchAddressView using ZStack
//                ZStack {
//                    TestSearchAddressView { location in
//                        self.selectedLocation = location
//                    }
//                    .padding(.horizontal)
//                    // .opacity(searchText.isEmpty ? 0 : 1) // Hide if search text is empty
//                }
//            )
        }
        .navigationTitle("Add Listing")
    }
    
    private func reverseGeocode(location: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let placemark = response?.mapItems.first?.placemark else {
                // Handle error
                return
            }
            let addressLine1 = "\(placemark.subThoroughfare ?? "") \(placemark.thoroughfare ?? "")"
            let address = Address(
                city: placemark.locality ?? "",
                country: placemark.country ?? "",
                zipCode: placemark.postalCode ?? "",
                addressLine1: addressLine1.trimmingCharacters(in: .whitespacesAndNewlines),
                addressLine2: ""
            )
            let geoLocoation = GeoLocation(
                lat: String(placemark.coordinate.latitude),
                long: String(placemark.coordinate.longitude)
            )
            listingDetail.address = address
            listingDetail.geoLocation = geoLocoation
            listingDetail.geoHash = "" // need to find a way to convert getloc to geohash
            print("Selected Address: ", address)
        }
    }
    
}

struct AddListingView_Previews: PreviewProvider {
    static var previews: some View {
        AddListingView()
    }
}
