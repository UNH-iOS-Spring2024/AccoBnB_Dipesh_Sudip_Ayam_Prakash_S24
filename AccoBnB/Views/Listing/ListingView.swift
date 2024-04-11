//
//  ListingView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct ListingView: View {
    @State private var searchText = ""
    @EnvironmentObject var listingViewModel: ListingViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                //                SearchBar(searchText: $searchText)
                //                    .padding(.top, 10)
                //                    .padding(.horizontal,20)
                if listingViewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(listingViewModel.listings, id: \.id) { listing in
                            ZStack {
                                ListingCardView(listingDetail: listing)
                                NavigationLink(destination: ListingDetailView(listingDetail: listing).environmentObject(bookingViewModel).navigationTitle(listing.title)) {
                                    EmptyView()
                                }.opacity(0)
                            }
                            
                        }.listRowSeparator(.hidden)
                        
                    }.navigationTitle("Listings")
                        .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                listingViewModel.getAllActiveListings()
            }
        }.padding(0)
    }
}


struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        let listingViewModel = ListingViewModel()
        let authViewModel = AuthViewModel() // Create an instance of AuthViewModel
        let bookingViewModel = BookingViewModel(authViewModel: authViewModel, text:"listingView")
        return ListingView()
            .environmentObject(listingViewModel)
            .environmentObject(bookingViewModel)
    }
}
