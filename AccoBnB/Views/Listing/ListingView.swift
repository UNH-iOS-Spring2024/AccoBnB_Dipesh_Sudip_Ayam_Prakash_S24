//
//  ListingView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct ListingView: View {
    
    @EnvironmentObject var listingViewModel: ListingViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if listingViewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(listingViewModel.filteredListings, id: \.id) { listing in
                            ZStack {
                                ListingCardView(listingDetail: listing)
                                NavigationLink(destination: ListingDetailView(listingDetail: listing).environmentObject(bookingViewModel).navigationTitle(listing.title)) {
                                    EmptyView()
                                }.opacity(0)
                            }
                            
                        }.listRowSeparator(.hidden)
                        
                    }
                    .navigationTitle("Listings")
                    .listStyle(PlainListStyle())
                    .searchable(text: $listingViewModel.searchText, prompt: "search housing")
                }
            }
            .onAppear {
                listingViewModel.getAllActiveListings(userId: nil)
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
