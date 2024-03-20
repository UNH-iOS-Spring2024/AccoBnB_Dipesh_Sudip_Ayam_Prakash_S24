//
//  ProfileView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//
import SwiftUI

struct MyProfileView: View {
    @State private var isLoggedIn = false // Assuming isLoggedIn state

    var body: some View {
        NavigationView {
            VStack {
                        
                HStack {
                    VStack {
                        Text("Test Test")
                            .bold()
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("test@test.com")
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Image(systemName: "person")
                        .padding(35)
                        .background(Color("primaryColor"))
                        .foregroundColor(Color.white)
                        .font(.system(size: 30))
                        .clipShape(Circle())
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 10)
                
                Divider()
                
                VStack {
                    BorderlessIconButtonView(buttonName: "Edit User Details", iconName: "person.crop.circle.badge.exclamationmark")
                    BorderlessIconButtonView(buttonName: "My Favorites", iconName: "heart.circle")
                    BorderlessIconButtonView(buttonName: "My Bookings", iconName: "list.bullet.circle")
                    BorderlessIconButtonView(buttonName: "Settings", iconName: "gearshape")
                    BorderlessIconButtonView(buttonName: "Help", iconName: "phone.bubble")
                    // Add the signout code here
                    NavigationLink(
                        destination: LoginView(),
                        isActive: $isLoggedIn,
                        label: {
                            CustomButtonView(buttonText: "Sign Out") {
                                isLoggedIn = true
                            }
                            .frame(width: UIScreen.main.bounds.width * 1, height: UIScreen.main.bounds.width * 0.5)
                        }
                    )
                }
                .padding(.vertical, 20)
                
                Spacer()
            }
            .navigationTitle("My Profile") // Moved the navigationTitle to the outer VStack
        }
        //            CustomButtonView(buttonText: "Log Out"){
        //                userStateVM.isLoggedIn = false
        //      
    }
}

struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
