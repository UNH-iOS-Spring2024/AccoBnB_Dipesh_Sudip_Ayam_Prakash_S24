//
//  ProfileView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var userStateVM: UserStateViewModel
    @State private var isEditUserDetailViewActive = false
    var body: some View {
        NavigationSplitView{
            VStack {
                
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
                .padding(.horizontal, 30)
                .padding(.vertical,10)
                
                Divider()
                
                VStack{
                    NavigationLink(destination: EditUserDetailView(), isActive: $isEditUserDetailViewActive){
                        BorderlessIconButtonView(buttonName: "Edit User Details", iconName: "person.crop.circle.badge.exclamationmark"){
                            isEditUserDetailViewActive = true
                        }
                    }
                    .navigationTitle("Profile")
                    
                    BorderlessIconButtonView(buttonName: "My Favorites", iconName: "heart.circle")
                    
                    BorderlessIconButtonView(buttonName: "My Bookings", iconName: "list.bullet.circle")
                    
                    BorderlessIconButtonView(buttonName: "Settings", iconName: "gearshape")
                    
                    BorderlessIconButtonView(buttonName: "Help", iconName: "phone.bubble")
                    
                }
                .padding(.vertical, 20)
                
                
                CustomButtonView(buttonText: "Log Out"){
                    userStateVM.isLoggedIn = false
                }
                
                Spacer()
            }
        }detail: {
            Text("See more")
        }
    }
}

#Preview {
    MyProfileView()
}
