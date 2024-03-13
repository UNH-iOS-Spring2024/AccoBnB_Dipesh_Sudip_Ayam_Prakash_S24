//
//  ListingView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct ListingView: View {
    @ObservedObject private var viewModel = ListingViewModel()
    
    var body: some View {
        NavigationSplitView{
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List{
                        ForEach(viewModel.listings, id: \.id){ listing in
                            NavigationLink{
                                ListingDetailView(listingDetail: listing)
                            } label:{
                                ListingCardView(listingDetail: listing)
                            }
                        }
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
