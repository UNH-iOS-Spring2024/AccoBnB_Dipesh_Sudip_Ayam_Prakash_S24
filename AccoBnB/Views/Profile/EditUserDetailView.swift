//
//  EditUserDetailView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/18/24.
//

import SwiftUI

struct EditUserDetailView: View {
    var body: some View {
        VStack{
            CustomTextFieldView(textHintString: "First Name", textFieldString: "", isSecureField: false)
            CustomTextFieldView(textHintString: "Last Name" , textFieldString: "", isSecureField: false)
            CustomTextFieldView(textHintString: "Email",textFieldString: "", isSecureField: false, isDisabled: true)
            CustomTextFieldView(textHintString: "Phone Number", textFieldString: "", isSecureField: false)
            CustomButtonView(buttonText: "Update"){
                print("User Detail Updated")
            }
        }
    }
}

#Preview {
    EditUserDetailView()
}
