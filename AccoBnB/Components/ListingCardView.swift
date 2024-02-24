//
//  ListingCardView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/24/24.
//

import SwiftUI

struct ListingCardView: View {
    @State var listingLocation: String // may be change to Location data class type later
    @State var listingTitle: String
    @State var listingType: String
    @State var listingPrice: Float
    @State var listingRating: Float // may be change to Rating data class type later
    
    
    var body: some View {
        VStack(alignment: .leading){
            //Image of listing
            Image("mt-everest")
                .resizable()
                .frame(width: .infinity, height: 200)
                .aspectRatio(contentMode: .fit)
            
            VStack(alignment: .leading){
                // Full Location
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                        .foregroundColor(Color("primaryColor"))
                    Text(listingLocation)
                        .foregroundColor(Color.gray)
                }
                .font(.system(size: 14))
                
                // Listing Title
                Text(listingTitle)
                    .bold()
                    .font(.headline)
                    .padding(.vertical,2)
                
                // Listing Type: Temporary, Permanent & price in HStack{}
                HStack{
                    HStack{
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color("primaryColor"))
                            .font(.system(size: 12))
                        Text(listingType)
                    }
                    Spacer()
                    Text("$"+String(listingPrice))
                }
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
                
                // Listing Rating
                ConciseRatingView(ratingValue: listingRating)
                    .padding(.bottom,5)
            }
            .padding(6)
            
        }
        .background(Color("secondaryColor"))
        .cornerRadius(8)
    }
}

#Preview {
    ListingCardView(listingLocation: "75 Admiral St, West Haven, CT, 06516", listingTitle: "1 Bed/ 1 Bath", listingType: "Temporary", listingPrice: 0, listingRating: 4.9)
}
