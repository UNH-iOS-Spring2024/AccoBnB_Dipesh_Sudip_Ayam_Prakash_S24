//
//  RegisterView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct RegisterView: View {
    @State var firstName: String
    @State var lastName: String
    @State var email: String
    @State var password: String
    @State var confirmPassword: String
    @State var isHost: Bool = false
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss // used to back stack to parent screen
    
    var body: some View {
        NavigationSplitView{
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
                
                CustomTextFieldView(placeholder: "First Name",text: $firstName, isSecureField: false)
                CustomTextFieldView(placeholder: "Last Name",text: $lastName, isSecureField: false)
                
                CustomTextFieldView(placeholder: "Email", text: $email, isSecureField: false)
                
                CustomTextFieldView(placeholder: "Password", text: $password, isSecureField: true)
                
                CustomTextFieldView(placeholder: "Confirm Password",text: $confirmPassword, isSecureField: true)
                
                Toggle("Are you an Host?", isOn: $isHost)
                    .padding(.horizontal, 30)
                    .foregroundColor(Color.gray)
                
                CustomButtonView(buttonText: "Register"){
                    var userRole = UserRole.guest
                    if isHost == true {
                        userRole = UserRole.host
                    }
                    Task{
                        try await authViewModel.signUp(withEmail: email.lowercased(), password: password, firstName: firstName, lastName: lastName, role: userRole)
                    }
                }
                    .padding(.top, 25)
                
                Button {
                    dismiss()
                } label: {
                    HStack{
                        Text("Already have an account?")
                            .foregroundColor(Color.gray)
                        
                        Text("Login")
                            .foregroundColor(Color("primaryColor"))
                            .bold()
                    }
                    .padding(.top, 25)
                }
                Spacer()
            }
        } detail: {
            Text("See more")
        }
    }
}

#Preview {
    RegisterView(firstName: "Dipesh", lastName: "Shrestha", email: "dipesh@gmail.com", password: "00000000000", confirmPassword: "00000000000")
}
