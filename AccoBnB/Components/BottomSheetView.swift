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
    // For Alert Box
    @State var isAlertPresented: Bool = false
    // Boolean variable passed as a parameter from parent view to check if the they wants to show alert box
    var showAlert: Bool
    var alertTitle: String?
    var alertMessage: String?
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
                    
                    // first show alert box, then perform actual button actions after confirmation in alertbox
                    if showAlert {
                        isAlertPresented = true
                    } else{
                        // if parent view doesn't want to show alertbox then perform the button actions right away
                        if !note.isEmpty {
                            onConfirm?(note, rating)
                            isPresented = false // Dismiss the BookingRequestView
                        }
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
        .alert(isPresented: $isAlertPresented) {
            // View dynamic title and message if passed as an parameter else view the standard title and message.
            if let alertTitle = alertTitle, let alertMessage = alertMessage {
                return Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton: .destructive(Text("Confirm")){
                        print("Confirm")
                        if !note.isEmpty {
                            onConfirm?(note, rating)
                            isPresented = false // Dismiss the BookingRequestView
                        }
                    },
                    secondaryButton: .default(Text("Dismiss")){
                        isAlertPresented = false
                    }
                )
            } else {
                return Alert(title: Text("Thank you!"), message: Text("Your request was processed."), dismissButton: .default(Text("OK")))
            }
        }
    }
}

#Preview {
    BottomSheetView(isPresented: .constant(true), viewTitle: "View Title", showAlert: false)
}
