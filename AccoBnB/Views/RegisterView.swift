//
//  RegisterView.swift
//  TestAccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct RegisterView: View {
    @State var fullName: String
    @State var email: String
    @State var password: String
    @State var confirmPassword: String
    
    var body: some View {
        VStack {
            Text("Register")
                .bold()
                .font(.title)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, 30)
                .padding(.bottom, 70)
            
            CustomButtonView(buttonText: "Register with Google")
            
            Text("-- OR --")
                .padding(.vertical, 30)
                .foregroundColor(Color.gray)
            
            CustomTextFieldView(textFieldString: fullName, isSecureField: false)
            
            CustomTextFieldView(textFieldString: email, isSecureField: false)
            
            CustomTextFieldView(textFieldString: password, isSecureField: true)
            
            CustomTextFieldView(textFieldString: confirmPassword, isSecureField: true)
            
            CustomButtonView(buttonText: "Register")
                .padding(.top, 25)
            
            VStack{
                Text("Already have an account?")
                    .foregroundColor(Color.gray)
                
                Text("Login")
                    .foregroundColor(Color("primaryColor"))
                    .bold()
            }
            .padding(.top, 25)
            
            Spacer()
        }
        Spacer()
    }
}

#Preview {
    RegisterView(fullName: "Dipesh", email: "Shrestha", password: "00000000000", confirmPassword: "dipesh@gmail.com")
}
