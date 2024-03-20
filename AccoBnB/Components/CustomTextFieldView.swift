//
//  CustomTextFieldView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct CustomTextFieldView: View {
    @State var textHintString: String
    @State var textFieldString: String
    @State var isSecureField: Bool
    @State var isDisabled: Bool? = false
    var body: some View {
        
        if(isSecureField){
            SecureField(textHintString, text: $textFieldString)
                .padding(12)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.black.opacity(0.06))
                .cornerRadius(8)
                .padding(.horizontal,30)
                .disabled(isDisabled!)
        }else{
            TextField(textHintString, text: $textFieldString)
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
    CustomTextFieldView(textHintString: "Hint",textFieldString: "", isSecureField: false)
}
