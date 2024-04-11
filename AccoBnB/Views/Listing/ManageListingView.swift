//
//  ManageListingView.swift
//  AccoBnB
//
//  Created by AP on 29/03/2024.
//


import SwiftUI
struct ManageListingView: View {
    @EnvironmentObject var listingViewModel: ListingViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    
    @State private var selectedListing: Listing? // Store the selected listing for editing
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if listingViewModel.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        List {
                            ForEach(listingViewModel.listings, id: \.id) { listing in
                                ZStack(alignment: .topTrailing) {
                                    ListingCardView(listingDetail: listing)
                                    
                                    // Edit Button
                                    Button(action: {
                                        selectedListing = listing
                                        print("SelectedListing", listing.title)
                                    }) {
                                        Image(systemName: "pencil")
                                            .padding()
                                            .background(Color.white) // As desired for button color
                                            .clipShape(Circle())
                                    }
                                    .contentShape(Rectangle()) // Clickable area = entire button
                                    .padding(8)
                                }
                            }
                            .navigationTitle("My Listings")
                        }.listStyle(PlainListStyle())
                        .padding(0)
                    }
                    Spacer()

                }
                .navigationTitle("Manage Listing")
                
                HStack {
                    Spacer()
                    NavigationLink(destination: AddListingView()) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.white)
                            .padding(16)
                            .background(Color("primaryColor"))
                            .clipShape(Circle())
                    }
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 30)
                    .padding(.bottom, 30)
                }
            }
            .onAppear {
                listingViewModel.getAllActiveListings(userId: "xap9z81gb2XFsULfi5mAsvWme792")
                if(authViewModel.userSession != nil){
                    listingViewModel.getAllActiveListings(userId: authViewModel.userSession!.uid)
                }
            }
        }
    }
}



struct ManageListingView_Previews: PreviewProvider {
    static var previews: some View {
        let listingViewModel = ListingViewModel()
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.defaultUser
        return ManageListingView()
            .environmentObject(listingViewModel)
            .environmentObject(authViewModel)
    }
}
