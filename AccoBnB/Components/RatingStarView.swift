//
//  RatingStarView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/31/24.
//

import SwiftUI

struct RatingStarView: View {
    @Binding var rating: Double?
    var starWidth = 40.0
    
    private func handleTap(index: Int, location: CGPoint){
        let isTappedOnTheLeftSideOfStar = location.x < starWidth/2
        rating = isTappedOnTheLeftSideOfStar ? Double(Double(index) - 0.5) : Double(index)
    }
    
    private func starType(index: Int) -> String{
        let roundedRating = ceil(rating ?? 0.0)
        // This condition applies to all indexes
//        print(rating)
        if Double(index) <= roundedRating {
            if Double(index) <= rating ?? 0.0{
                return "star.fill"
            } else {
                return "star.leadinghalf.fill"
            }
        }
        return "star"
    }
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self){ index in
                Image(systemName: starType(index: index))
                    .font(.largeTitle)
                    .foregroundColor(Color.yellow)
                    .onTapGesture (coordinateSpace: .local, perform: {
                        handleTap(index: index, location: $0)
                    })
            }
        }
    }
}

#Preview {
    RatingStarView(rating: .constant(0.0))
}
