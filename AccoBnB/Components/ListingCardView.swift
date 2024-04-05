//
//  ListingCardView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/24/24.
//

import SwiftUI

struct ListingCardView: View {
    @State var listingDetail: Listing

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                // Load image from URL using AsyncImage
                if let url = URL(string: listingDetail.bannerImage) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .frame( height: 200)
                                .aspectRatio(contentMode: .fit)
                                
                        case .failure:
                            Image("mt-everest")
                                .resizable()
                                .frame(height: 200)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom, 8)
                } else {
                    // Use a placeholder if the URL is invalid
                    Image("mt-everest")
                        .resizable()
                        .frame(height: 200)
                        .aspectRatio(contentMode: .fit)
                        .padding(.bottom, 8)
                        .foregroundColor(.gray)
                }
            }

            VStack(alignment: .leading) {
                // Full Location
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color("primaryColor"))
                    Text("\(listingDetail.address?.addressLine1 ?? "Unknown"), \(listingDetail.address?.city ?? "Unknown"), \(listingDetail.address?.zipCode ?? "Unknown")")
                        .foregroundColor(Color.gray)
                }
                .font(.system(size: 14))

                // Listing Title
                Text(listingDetail.title)
                    .bold()
                    .font(.headline)
                    .padding(.vertical, 2)

                // Listing Type: Temporary, Permanent & price in HStack{}
                HStack {
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color("primaryColor"))
                            .font(.system(size: 12))
                        Text(listingDetail.type.rawValue)
                    }
                    Spacer()
                    Text("$" + (listingDetail.type == .rental ? String(listingDetail.monthlyPrice) + "/month" : String(listingDetail.dailyPrice) + "/day"))
                }
                .font(.system(size: 14))
                .foregroundColor(Color.gray)

                // Listing Rating
                ConciseRatingView(ratingValue: listingDetail.rating)
                    .padding(.bottom, 5)
            }
            .padding(6)
        }
        .background(Color("secondaryColor"))
        .cornerRadius(8)
    }
}



#Preview {
    let newListing = Listing.defaultListing
    return ListingCardView(listingDetail: newListing)
}
