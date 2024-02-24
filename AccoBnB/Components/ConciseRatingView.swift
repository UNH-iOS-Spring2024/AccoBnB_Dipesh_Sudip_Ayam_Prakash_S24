//
//  ConciseRatingView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/24/24.
//

import SwiftUI

struct ConciseRatingView: View {
    @State var ratingValue: Float
    var body: some View {
        HStack{
            Image(systemName: "star.fill")
                .foregroundColor(Color.white)
                
            Text(String(ratingValue))
                .foregroundColor(Color.white)
        }
        .font(.system(size: 12))
        .padding(3)
        .background(Color("primaryColor"))
        .cornerRadius(4)
    }
}

#Preview {
    ConciseRatingView(ratingValue: 4.9)
}
