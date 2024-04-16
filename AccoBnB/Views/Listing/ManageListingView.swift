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
    @EnvironmentObject var bookingViewModel: BookingViewModel
    
    
    @State private var selectedListing: Listing? // Store the selected listing for editing
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack {
                    if listingViewModel.isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .padding()
                    } else {
                        List {
                            ForEach(listingViewModel.hostListings, id: \.id) { listing in
                                ZStack(alignment: .topTrailing) {
                                    ZStack {
                                        ListingCardView(listingDetail: listing)
                                        NavigationLink(destination: ListingDetailView(listingDetail: listing).environmentObject(bookingViewModel).navigationTitle(listing.title)) {
                                            EmptyView()
                                        }.opacity(0)
                                    }
                                    
                                    // Edit Button
                                    Image(systemName: "pencil")
                                        .padding()
                                        .background(Color.white) // As desired for button color
                                        .clipShape(Circle())
                                        .onTapGesture {
                                            selectedListing = listing
                                        }
                                        .contentShape(Rectangle()) // Clickable area = entire button
                                        .padding(8)
                                }
                                .overlay(
                                    NavigationLink(
                                        destination: AddListingView(listing: selectedListing ?? Listing()),
                                        isActive: .constant(selectedListing?.id == listing.id),
                                        label: { EmptyView() }
                                    )
                                    .hidden()
                                )
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
                    NavigationLink(destination: AddListingView(listing: Listing())) {
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
                if authViewModel.currentUser != nil {
                    print("HELLO", authViewModel.currentUser?.id)
                    listingViewModel.getAllActiveListings(userId: authViewModel.currentUser!.id)
                }
                selectedListing = nil
            }
        }
    }
}



struct ManageListingView_Previews: PreviewProvider {
    static var previews: some View {
        let listingViewModel = ListingViewModel()
        let authViewModel = AuthViewModel()
        authViewModel.currentUser = User.defaultHostUser
        return ManageListingView()
            .environmentObject(listingViewModel)
            .environmentObject(authViewModel)
    }
}
