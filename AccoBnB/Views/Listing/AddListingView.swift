//
//  AddListingView.swift
//  AccoBnB
//
//  Created by AP on 29/03/2024.
//

import SwiftUI

struct AddListingView: View {
    @State private var title = ""
    @State private var description = ""
    @State private var listingType = "Rental"
    @State private var availableRooms = "1"
    @State private var price = ""
    @State private var address = ""
    @State private var aptSuite = ""
    @State private var city = ""
    @State private var zipCode = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextEditor(text: $description)
                    .frame(minHeight: 100)
                    .border(Color.gray, width: 1)
                
                Picker("Listing Type", selection: $listingType) {
                    Text("Rental").tag("Rental")
                    Text("Temporary").tag("Temporary")
                }
                .pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    Text("Available Rooms")
                    Spacer()
                    TextField("Rooms", text: $availableRooms)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                HStack {
                    Text("Price")
                    Spacer()
                    TextField("Price", text: $price)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                TextField("Address", text: $address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Apt, Suite, etc", text: $aptSuite)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                HStack {
                    TextField("City", text: $city)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("ZipCode", text: $zipCode)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                CustomButtonView(buttonText: "Submit"){
                }
            }
            .padding()
        }
        .navigationTitle("Add Listing")
    }
}

struct AddListingView_Previews: PreviewProvider {
    static var previews: some View {
        AddListingView()
    }
}
