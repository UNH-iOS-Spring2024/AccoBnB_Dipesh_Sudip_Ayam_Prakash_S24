//
//  ProfileView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct MyProfileView: View {
    var body: some View {
        VStack {
            Text("My Profile")
                .bold()
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding(.bottom, 40)
            
            HStack{
                VStack{
                    Text("Test Test")
                        .bold()
                        .font(.headline)
                        .frame(maxWidth: .infinity,alignment: .leading)
                    
                    Text("test@test.com")
                        .bold()
                        .font(.subheadline)
                        .tint(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Image(systemName: "person")
                    .padding(35)
                    .background(Color("primaryColor"))
                    .foregroundColor(Color.white)
                    .font(.system(size: 30))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            }
            .padding(.vertical,10)
            
            Divider()
            
            VStack{
                
                BorderlessIconButtonView(buttonName: "Edit User Details", iconName: "person.crop.circle.badge.exclamationmark")
                
                BorderlessIconButtonView(buttonName: "My Favorites", iconName: "heart.circle")
                
                BorderlessIconButtonView(buttonName: "My Bookings", iconName: "list.bullet.circle")
                
                BorderlessIconButtonView(buttonName: "Settings", iconName: "gearshape")
                
                BorderlessIconButtonView(buttonName: "Help", iconName: "phone.bubble")
                
            }
            .padding(.vertical, 20)
            
            
            CustomButtonView(buttonText: "Log Out")
            
            Spacer()
        }
            .padding(.horizontal, 10)
    }
}

#Preview {
    MyProfileView()
}
