//
//  ListingDetailView.swift
//  AccoBnB
//
//  Created by AP on 12/03/2024.
//

import SwiftUI

struct ListingDetailView: View {
    @State var listingDetail: Listing
    var body: some View {
        Text(listingDetail.title)
    }
}

#Preview {
    let newListing = Listing.defaultListing
    return ListingDetailView(listingDetail: newListing)
}
