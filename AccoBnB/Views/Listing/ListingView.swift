//
//  ListingView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct ListingView: View {
    @State private var searchText = ""
    @EnvironmentObject var viewModel: ListingViewModel
    @EnvironmentObject var bookingViewModel: BookingViewModel 

    var body: some View {
        NavigationSplitView {
            VStack {
//                SearchBar(searchText: $searchText)
//                    .padding(.top, 10)
//                    .padding(.horizontal,20)
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.listings, id: \.id) { listing in
                            NavigationLink(destination: ListingDetailView(listingDetail: listing).environmentObject(bookingViewModel)) {
                                ListingCardView(listingDetail: listing)
                            }
                        }
                        .navigationTitle("Listings")
                    }
                }
            }
            .onAppear {
                viewModel.getAllListings()
            }
        } detail: {
            Text("Show me")
        }
    }
}


struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        let listingViewModel = ListingViewModel()
        let bookingViewModel = BookingViewModel(text:"listingView")
        return ListingView()
            .environmentObject(listingViewModel)
            .environmentObject(bookingViewModel)
    }
}
