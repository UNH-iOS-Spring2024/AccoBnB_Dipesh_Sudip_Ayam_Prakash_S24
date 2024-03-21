//
//  CustomTextFieldView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct CustomTextFieldView: View {
    var placeholder: String
    @Binding var text: String
    var isSecureField: Bool
    var isDisabled: Bool? = false
    
    var body: some View {
        
        if(isSecureField){
            SecureField(placeholder, text: $text)
                .padding(12)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.black.opacity(0.06))
                .cornerRadius(8)
                .padding(.horizontal,30)
                .disabled(isDisabled!)
        }else{
            TextField(placeholder, text: $text)
                .padding(12)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.black.opacity(0.06))
                .cornerRadius(8)
                .padding(.horizontal,30)
                .disabled(isDisabled!)
        }
    }
}

#Preview {
    CustomTextFieldView(placeholder: "Hint", text: .constant(""), isSecureField: false)
}
