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
    @State private var listingDetail: Listing
    @State private var selectedLocation: MKLocalSearchCompletion?
    @State private var selectedPhoto: UIImage?
    @State private var isShowingImagePicker = false
    @State private var isShowingCamera = false
    @EnvironmentObject var listingViewModel: ListingViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isTextFieldFocused = false
    @State private var showSearchAddressBottomSheet = false
    @Environment(\.dismiss) var dismiss
    @State private var isAlertPresented = false
    @State private var alertTitle: String?
    @State private var alertMessage: String?

    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        isAlertPresented = true
    }
    
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
                if let photo = selectedPhoto  {
                    Image(uiImage: photo)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 250)
                        .clipped()
                        .padding()
                    Button("Choose Another Photo") {
                        selectedPhoto = nil
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
                .padding(.horizontal, 30)
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
                        .padding(.horizontal, 10)
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
                CustomButtonView(buttonText: listingDetail.id.isEmpty ? "Add" : "Update") {
                    guard isInputValid() else {
                        return
                    }
                    listingDetail.hostId = authViewModel.currentUser?.id ?? ""
                    if let location = selectedLocation {
                        reverseGeocode(location: location)
                    }
                      let updateMethod = listingDetail.id.isEmpty ? listingViewModel.createListing : listingViewModel.updateListing
                    
                    Task{
                         updateMethod(selectedPhoto, &listingDetail){ result in
                            switch result {
                            case .success(_):
                                // Reset selected values after successful creation or update
                                self.listingDetail = Listing()
                                self.selectedLocation = nil
                                self.selectedPhoto = nil
                                dismiss()
                            case .failure(let error):
                                let action = listingDetail.id.isEmpty ? "create" : "update"
                                print("Failed to \(action) listing: \(error)")
                            }
                        }
                    }
                }
            }
            .onAppear{
                guard let url = URL(string: listingDetail.bannerImage) else {return}
                
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    } else if let data = data {
                        DispatchQueue.main.async {
                            self.selectedPhoto = UIImage(data: data)
                        }
                    }
                }.resume()
            }
            .padding()
        }
        .alert(isPresented: $isAlertPresented) {
            if let alertTitle = alertTitle, let alertMessage = alertMessage {
                return Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage)
                )
            } else {
                // Default alert if no specific title and message are provided
                return Alert(title: Text("Validation Error"), message: Text("Please fill out all required fields."), dismissButton: .default(Text("OK")))
            }
        }
        .navigationTitle(listingDetail.id.isEmpty ? "Add Listing" : "Edit Listing")
    }
    
    private func isInputValid() -> Bool {
        if listingDetail.title.isEmpty {
            showAlert(title: "Title Required", message: "Please enter a title.")
            return false
        }
        
        if listingDetail.description.isEmpty {
            showAlert(title: "Description Required", message: "Please enter a description.")
            return false
        }
        
        if listingDetail.type == .rental && listingDetail.availableRooms == 0 {
            showAlert(title: "Available Rooms Required", message: "Number of available rooms is required for rental type.")
            return false
        }
        
        if listingDetail.type == .temporary && listingDetail.guestCount == 0 {
            showAlert(title: "Guest Count Required", message: "Guest count is required for temporary type.")
            return false
        }
        
        if listingDetail.type == .rental && listingDetail.monthlyPrice == 0 {
            showAlert(title: "Price Required", message: "Price is required for rental type.")
            return false
        }
        
        if listingDetail.type == .temporary && listingDetail.dailyPrice == 0 {
            showAlert(title: "Price Required", message: "Price is required for temporary type.")
            return false
        }
        
        if listingDetail.amenities.isEmpty {
            showAlert(title: "Amenities Required", message: "At least one amenity is required.")
            return false
        }
        
        if listingDetail.hostId.isEmpty {
            showAlert(title: "Host ID Required", message: "Need logged in user to add listing.")
            return false
        }
        
        if listingDetail.address.addressLine1.isEmpty ||
            listingDetail.address.city.isEmpty ||
            listingDetail.address.zipCode.isEmpty {
            showAlert(title: "Address Required", message: "Address, city, and zip code are required.")
            return false
        }
        
        return true
    }

    
    
    private func reverseGeocode(location: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: location)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let placemark = response?.mapItems.first?.placemark else {
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
            listingDetail.geoHash = ""
        }
    }
    
}

struct AddListingView_Previews: PreviewProvider {
    static var previews: some View {
        return AddListingView(listing: Listing())
    }
}

