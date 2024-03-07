//
//  LoginView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct LoginView: View {
    @State var email: String
    @State var password: String
    
    var body: some View {
        VStack {
            Text("Login")
                .bold()
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 10)
                .padding(.horizontal, 30)
                .padding(.bottom, 70)
            
            CustomButtonView(buttonText: "Login in with Google")
            
            Text("OR")
                .foregroundColor(Color.gray)
                .padding(.vertical, 30)
            
            CustomTextFieldView(textFieldString: email, isSecureField: false)
            
            CustomTextFieldView(textFieldString: password, isSecureField: true)
            
            CustomButtonView(buttonText: "Login"){
                userStateVM.isLoggedIn = true
            }
                .padding(.top, 25)
            
            VStack{
                Text("Are you a new user?")
                    .foregroundColor(Color.gray)
                
                Text("Register")
                    .foregroundColor(Color("primaryColor"))
                    .bold()
            }
            .padding(.top, 25)
        }
            
        Spacer()
    }
}

#Preview {
    LoginView(email: "test@test.com", password: "test")
}
