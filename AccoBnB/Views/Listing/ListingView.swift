//
//  ListingView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct ListingView: View {
    @ObservedObject private var viewModel = ListingViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationSplitView {
            VStack {
                
                SearchBar(searchText: $searchText)
                    .padding(.top, 10)
                    .padding(.horizontal,20)
                    
                

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(viewModel.listings, id: \.id) { listing in
                            NavigationLink(destination: ListingDetailView(listingDetail: listing)) {
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
        ListingView()
    }
}
