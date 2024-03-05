//
//  CustomTextFieldView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct CustomTextFieldView: View {
    @State var textFieldString: String
    @State var isSecureField: Bool
    var body: some View {
        
        if(isSecureField){
            SecureField("Full Name", text: $textFieldString)
                .padding(12)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.black.opacity(0.06))
                .cornerRadius(8)
        }else{
            TextField("Full Name", text: $textFieldString)
                .padding(12)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                .background(Color.black.opacity(0.06))
                .cornerRadius(8)
        }
    }
}

#Preview {
    CustomTextFieldView(textFieldString: "Text Field", isSecureField: false)
}
