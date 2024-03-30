//
//  ManageListingView.swift
//  AccoBnB
//
//  Created by AP on 29/03/2024.
//


import SwiftUI

struct ManageListingView: View {
    @EnvironmentObject var listingViewModel: ListingViewModel
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
                                ListingCardView(listingDetail: listing)

                            }
                            .navigationTitle("Listings")
                        }.listStyle(PlainListStyle())
                        .padding(0)
                    }
                    Spacer()
                    HStack {
                        //                    Button(action: {
                        //                        // Action for adding a listing
                        //                    }) {
                        //                        Image(systemName: "plus")
                        //                            .resizable()
                        //                            .frame(width: 24, height: 24)
                        //                            .foregroundColor(Color.white)
                        //                            .padding(16)
                        //                            .background(Color("primaryColor"))
                        //                            .clipShape(Circle())
                        //                    }
                        //                    .padding(.trailing, 20)
                        //                    .padding(.bottom, 60)
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
                        .padding(.trailing, 20)
                        .padding(.bottom, 60)
                    }
                }
                .navigationTitle("Manage Listing")
            }
            .onAppear {
                listingViewModel.getAllListings()
            }
        }
    }
}

struct TestAddListingView: View {
    @State var listingDetail: Listing
    var body: some View {
        Text(listingDetail.title)
            .navigationTitle("Add Listing")
    }
}


struct ManageListingView_Previews: PreviewProvider {
    static var previews: some View {
        let listingViewModel = ListingViewModel()
        ManageListingView()
            .environmentObject(listingViewModel)
    }
}
