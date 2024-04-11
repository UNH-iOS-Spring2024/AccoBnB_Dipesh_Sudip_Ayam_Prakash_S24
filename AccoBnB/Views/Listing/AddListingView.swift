//
//  AddListingView.swift
//  AccoBnB
//
//  Created by AP on 29/03/2024.
//

import SwiftUI
import MapKit
import PhotosUI

struct AddListingView: View {
    @State private var listingDetail: Listing // Remove the @State wrapper
    @State private var selectedLocation: MKLocalSearchCompletion?
    @State private var selectedPhoto: UIImage? // Store selected photo
    @State private var isShowingImagePicker = false // Control showing the image picker
    @State private var isShowingCamera = false // Control showing the camera
    @EnvironmentObject var listingViewModel: ListingViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    //@FocusState private var isAddressSearching: Bool
    @State private var isTextFieldFocused = false
    @State private var showSearchAddressBottomSheet = false
    
    init(listing: Listing?) {
        if let listing = listing {
            _listingDetail = State(initialValue: listing)
        } else {
            _listingDetail = State(initialValue: Listing())
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                TextField("Title", text: $listingDetail.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $listingDetail.description)
                    .frame(minHeight: 100)
                    .border(Color.gray.opacity(0.2), width: 1)
                //image here
                if let photo = selectedPhoto {
                    Image(uiImage: photo)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                    
                    Button("Choose Another Photo") {
                        selectedPhoto = nil // Clear the selected photo
                        isShowingImagePicker.toggle()
                    }
                    .padding()
                } else {
                    HStack {
                        Button("Take Photo") {
                            isShowingCamera = true
                            isShowingImagePicker.toggle()
                        }
                        .padding()
                        
                        Button("Choose from Library") {
                            isShowingCamera = false
                            isShowingImagePicker.toggle()
                        }
                        .padding()
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                        isShowingImagePicker = false
                    }, content: {
                        ImagePicker(selectedImage: $selectedPhoto, isShowingImagePicker: $isShowingImagePicker, isShowingCamera: $isShowingCamera)
                    })
                }
                
                // image end here
                
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
                            set: { if let value = Int($0) { listingDetail.guestCount = value } }
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
                
                Button {
                    
                    self.showSearchAddressBottomSheet = true
                }
            label: {
                TextField("Search Address", text: self.$listingDetail.address.addressLine1, onCommit: {
                    self.showSearchAddressBottomSheet = true
                })
                .padding(.horizontal, 30) // Adjust padding as necessary
                .padding(10)
                .background(Color(UIColor.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                            .padding(.trailing, 5)
                        Spacer()
                    }
                        .padding(.horizontal, 10) // Adjust padding as necessary
                )
                .padding(.horizontal)
                
                .sheet(isPresented: $showSearchAddressBottomSheet) {
                    AddressSearchBarView { location in
                        self.showSearchAddressBottomSheet = false
                        self.selectedLocation = location
                        if let location = selectedLocation {
                            reverseGeocode(location: location)
                        }
                    }
                }
            }
                
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
                    listingDetail.hostId = authViewModel.userSession?.uid ?? ""
                    if let location = selectedLocation {
                        reverseGeocode(location: location)
                    }
                    guard isInputValid() else {
                        // Handle invalid input condition
                        return
                    }
                    print("New Listing:", listingDetail)
                    listingViewModel.createListing(bannerImagePath: selectedPhoto, listing: &listingDetail) { result in
                        switch result {
                        case .success(let createdListing):
                            self.listingDetail = Listing()
                            self.selectedLocation = nil
                            self.selectedPhoto = nil
                        case .failure(let error):
                            print("Failed to create listing: \(error)")
                            // Handle the error, such as showing an alert to the user
                        }
                    }
                    
                }
            }
            .padding()
        }
        .navigationTitle("Add Listing")
    }
    
    private func isInputValid() -> Bool {
        var isValid = true
        
        if listingDetail.title.isEmpty {
            // Show error for title field
            isValid = false
            print("Title is required.")
        }
        
        if listingDetail.description.isEmpty {
            // Show error for description field
            isValid = false
            print("Description is required.")
        }
        
        if listingDetail.type == .rental && listingDetail.availableRooms == 0 {
            // Show error for available rooms field if listing type is rental
            isValid = false
            print("Number of available rooms is required for rental type.")
        }
        
        if listingDetail.type == .temporary && listingDetail.guestCount == 0 {
            // Show error for guest count field if listing type is temporary
            isValid = false
            print("Guest count is required for temporary type.")
        }
        
        if listingDetail.type == .rental && listingDetail.monthlyPrice == 0 {
            // Show error for monthly price field if listing type is rental
            isValid = false
            print("Price is required for rental type.")
        }
        
        if listingDetail.type == .temporary && listingDetail.dailyPrice == 0 {
            // Show error for daily price field if listing type is temporary
            isValid = false
            print("Price is required for temporary type.")
        }
        
        if listingDetail.amenities.isEmpty {
            // Show error for amenities
            isValid = false
            print("At least one amenity is required.")
        }
        
        if listingDetail.hostId.isEmpty {
            // Show error for hostid
            isValid = false
            print("Need logged in user to add listing")
        }
        
        if listingDetail.address.addressLine1.isEmpty ||
            listingDetail.address.city.isEmpty ||
            listingDetail.address.zipCode.isEmpty {
            // Show error for address fields
            isValid = false
            print("Address, city, and zip code are required.")
        }
        
        if !isValid {
            print("Please fill out the required fields.")
        }
        
        return isValid
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
        return AddListingView(listing: Listing())
    }
}

