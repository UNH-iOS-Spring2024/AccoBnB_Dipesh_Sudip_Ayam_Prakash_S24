//
//  CustomButtonView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct CustomButtonView: View {
    @State var buttonText: String
    @State var color: String = "primaryColor"
    var btnClickAction: (()->Void)?
    var body: some View {
        Button{
            if (btnClickAction) != nil{
                btnClickAction!()
            }
        }label: {
            Text(buttonText)
                .padding(.vertical,4)
                .font(.system(size: 18))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(color))
        .padding(.horizontal, 30)
    }
}

#Preview {
    CustomButtonView(buttonText: "ButtonText")
}
