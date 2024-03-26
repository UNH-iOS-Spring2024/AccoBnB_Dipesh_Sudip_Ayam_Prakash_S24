//
//  LoginView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        NavigationSplitView{
            VStack {
                Text("Login")
                    .bold()
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 90)
                
//                CustomButtonView(buttonText: "Login in with Google")
//                
//                Text("OR")
//                    .foregroundColor(Color.gray)
//                    .padding(.vertical, 30)
                
                CustomTextFieldView(placeholder:"Email Address", text: $email, isSecureField: false)
                
                CustomTextFieldView(placeholder:"Password", text: $password, isSecureField: true)
                
                CustomButtonView(buttonText: "Login"){
                    Task{
                        try await authViewModel.signIn(withEmail: email, password: password)
                    }
                    
                }
                    .padding(.top, 25)
                
                NavigationLink{
                    RegisterView(firstName: "", lastName: "", email: "", password: "", confirmPassword: "")
                        .navigationBarBackButtonHidden(true)
                } label:{
                    HStack{
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
            .padding(.top, 12)
        } detail: {
            Text("See more")
        }
    }
}

#Preview {
    LoginView()
}
