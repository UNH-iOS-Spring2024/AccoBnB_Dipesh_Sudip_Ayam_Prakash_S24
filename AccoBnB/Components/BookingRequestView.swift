//
//  BookingRequestView.swift
//  AccoBnB
//
//  Created by AP on 19/03/2024.
//

import SwiftUI

struct BookingRequestView: View {
    @Binding var isPresented: Bool
    var onConfirm: ((String) -> Void)? // Closure to handle confirm action
    
    @State private var bookingNote = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Booking Request")
                .font(.title)
                .fontWeight(.bold)
            
            TextField("Add your message..", text: $bookingNote)
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
                    if !bookingNote.isEmpty {
                        // Call the confirm action closure
                        onConfirm?(bookingNote)
                        isPresented = false // Dismiss the BookingRequestView
                    }
                }
                .cornerRadius(8)
                .disabled(bookingNote.isEmpty)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    BookingRequestView(isPresented: .constant(true))
}
