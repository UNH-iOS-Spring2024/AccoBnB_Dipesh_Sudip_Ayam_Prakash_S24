//
//  BorderlessIconButtonView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct BorderlessIconButtonView: View {
    @State var buttonName: String
    @State var iconName: String
    @State var btnClickAction: (() -> Void)?
    
    var body: some View {
        Button{
            if btnClickAction != nil{
                btnClickAction!()
            }
        }label: {
            Image(systemName: iconName)
                .resizable()
                .frame(width: 28, height: 28)
                .tint(Color("primaryColor"))
            Text(buttonName)
                .font(.system(size: 18))
                .foregroundColor(Color.black)
        }
        .buttonStyle(.borderless)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 30)
        .padding(.vertical, 5)
    }
}

#Preview {
    BorderlessIconButtonView(buttonName: "Button Name", iconName: "list.bullet.circle")
}
