//
//  ProfileView.swift
//  AccoBNB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct MyProfileView: View {
    @ObservedObject private var userProfileVM = UserProfileViewModel()
    @EnvironmentObject var authVM: AuthViewModel
    
    @State private var isEditUserDetailViewActive = false
    
    var body: some View {
        NavigationSplitView{
            VStack {
                if userProfileVM.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }else{
                    HStack{
                        VStack{
                            Text("\(userProfileVM.userDetail.firstName) å\(userProfileVM.userDetail.lastName)")
                                .bold()
                                .font(.headline)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .padding(.bottom,2)
                            
                            Text(userProfileVM.userDetail.email )
                                .font(.system(size: 12))
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
                        NavigationLink(destination: EditUserDetailView(userDetail: userProfileVM.userDetail), isActive: $isEditUserDetailViewActive){
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
                        authVM.signOut()
                    }
                    
                    Spacer()
                }
            }
            .onAppear{
                userProfileVM.getUserDetails(userId: authVM.currentUser!.id)
            }
        }detail: {
            Text("See more")
        }
    }
}

#Preview {
    MyProfileView()
}
