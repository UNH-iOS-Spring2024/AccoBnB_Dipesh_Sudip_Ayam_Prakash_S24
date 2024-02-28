//
//  CustomButtonView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct CustomButtonView: View {
    @State var buttonText: String
    // Making this parameter optional using "?"
    var onBtnClick: (() -> Void)?
    var body: some View {
        Button{
            if((onBtnClick) != nil){
                // Unwrapping an optional value
                onBtnClick!()
            }
        }label: {
            Text(buttonText)
                .padding(.vertical,4)
                .font(.system(size: 18))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color("primaryColor"))
    }
}

#Preview {
    CustomButtonView(buttonText: "ButtonText")
}
