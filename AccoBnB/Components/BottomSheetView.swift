//
//  BookingRequestView.swift
//  AccoBnB
//
//  Created by AP on 19/03/2024.
//

import SwiftUI

struct BottomSheetView: View {
    @Binding var isPresented: Bool
    var viewTitle: String
    var isRatingViewDisabled: Bool = true
    var onConfirm: ((String, Double?) -> Void)? // Closure to handle confirm action
    
    @State private var note = ""
    @State var rating: Double?
    
    var body: some View {
        VStack(spacing: 20) {
            Text(viewTitle)
                .font(.title)
                .fontWeight(.bold)
            
            if isRatingViewDisabled {
                RatingStarView(rating: $rating)
                    .hidden()
            } else {
                RatingStarView(rating: $rating)
            }
            
            TextField("Add your message..", text: $note)
                .textFieldStyle(PlainTextFieldStyle()) // Remove default styling
                .padding()
                .frame(minHeight: 120) // Adjust the height
                .background(Color.white) // Add background color
                .cornerRadius(10) // Add corner radius
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1) // Add border
                )
            
            HStack {
                CustomButtonView(buttonText: "Close",color:"tertiaryColor"){
                    isPresented = false // Dismiss the BookingRequestView
                }
                .cornerRadius(8)
                Spacer()
                CustomButtonView(buttonText: "Confirm"){
                    if !note.isEmpty {
                        onConfirm?(note, rating)
                        isPresented = false // Dismiss the BookingRequestView
                    }
                }
                .cornerRadius(8)
                .disabled((!isRatingViewDisabled && rating == nil) || (note.isEmpty))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    BottomSheetView(isPresented: .constant(true), viewTitle: "View Title")
}
