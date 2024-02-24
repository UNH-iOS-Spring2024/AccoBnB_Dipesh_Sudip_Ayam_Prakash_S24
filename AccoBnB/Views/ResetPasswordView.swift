//
//  ResetPasswordView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct ResetPasswordView: View {
    @State var email: String
    var descPart1 = AttributedString("Please enter your")
    var descPart2: AttributedString{
        var res = AttributedString(" email address ")
        res.foregroundColor = Color("primaryColor")
        return res
    }
    var descPart3 = AttributedString("to reset your password.")
    
    var body: some View {
        Text("Reser Password")
            .bold()
            .font(.title)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.horizontal, 30)
            .padding(.top, 10)
            .padding(.bottom, 30)
        
        Text(descPart1+descPart2+descPart3)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            .padding(.horizontal, 30)
        
        CustomTextFieldView(textFieldString: email , isSecureField: false)
            .padding(.top, 50)
        
        CustomButtonView(buttonText: "Reset")
            .padding(.top, 20)
        
        Spacer()
    }
}

#Preview {
    ResetPasswordView(email: "test@test.com")
}
