//
//  CustomButtonView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct CustomButtonView: View {
    @State var buttonText: String
    var body: some View {
        Button{
            
        }label: {
            Text(buttonText)
                .padding(.vertical,4)
                .font(.system(size: 18))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color("primaryColor"))
        .padding(.horizontal, 30)
    }
}

#Preview {
    CustomButtonView(buttonText: "ButtonText")
}
