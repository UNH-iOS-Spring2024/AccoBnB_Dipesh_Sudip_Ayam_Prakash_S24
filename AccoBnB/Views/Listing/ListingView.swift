//
//  ListingView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct ListingView: View {
    @StateObject private var viewModel = ListingViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            } else {
                List(viewModel.listings, id: \.id) { listing in
                    Text(listing.title)
                }
            }
        }
        .onAppear {
            viewModel.getAllListings()
        }
    }
}

struct ListingView_Previews: PreviewProvider {
    static var previews: some View {
        ListingView()
    }
}
