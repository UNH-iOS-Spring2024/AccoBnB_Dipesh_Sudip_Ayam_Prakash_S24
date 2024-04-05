//
//  ReviewCardView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/13/24.
//

import SwiftUI

struct ReviewCardView: View {
    @State var ratingValue: Float
    @State var date: String
    @State var reviewerName: String
    @State var comment: String
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                ConciseRatingView(ratingValue: ratingValue)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Text(date)
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                Spacer()
            }
            // Reviewer Name
            Text(reviewerName)
                .padding(.top, 5)
                .padding(.bottom, 5)
                .font(.system(size: 16))
                .foregroundColor(.gray)
            // Review Comment
            Text(comment)
        }
    }
}

#Preview {
    ReviewCardView(ratingValue: 4.2, date: "22nd Mar, 2023", reviewerName: "Anonymous", comment: "This is brilliant flat")
}
