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
    @State var isAlertPresented: Bool = false
    var showAlert: Bool
    var alertTitle: String?
    var alertMessage: String?
    var onConfirm: ((String, Double?) -> Void)?
    
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
            
            TextEditor(text: $note)
                .textFieldStyle(PlainTextFieldStyle())
                .padding()
                .frame(minHeight: 120)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            HStack {
                CustomButtonView(buttonText: "Close",color:"tertiaryColor"){
                    isPresented = false
                }
                .cornerRadius(8)
                Spacer()
                CustomButtonView(buttonText: "Confirm"){
                    
                  
                    if showAlert {
                        isAlertPresented = true
                    } else{
                      
                        if !note.isEmpty {
                            onConfirm?(note, rating)
                            isPresented = false
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
           
            if let alertTitle = alertTitle, let alertMessage = alertMessage {
                return Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    primaryButton: .destructive(Text("Dismiss")){
                            isAlertPresented = false
                    },
                    secondaryButton: .default(Text("Confirm")){
                        print("Confirm")
                        if !note.isEmpty {
                            onConfirm?(note, rating)
                            isPresented = false
                        }
                    }
                )
            } else {
                return Alert(title: Text("Thank you!"), message: Text("Your request was processed."), dismissButton: .default(Text("OK")))
            }
        }
    }
}


struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isPresented: .constant(true), viewTitle: "View Title", showAlert: true, alertTitle: "Confirm Review?", alertMessage: "Please click on the Confirm button to post your review.")
    }
}
