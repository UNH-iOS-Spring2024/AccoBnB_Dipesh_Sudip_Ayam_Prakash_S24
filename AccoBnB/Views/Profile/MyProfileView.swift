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
    @ObservedObject private var viewModel = UserProfileViewModel()
    
    var body: some View {
        NavigationSplitView{
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }else{
                    HStack{
                        VStack{
                            Text("\(viewModel.userDetail.firstName) \(viewModel.userDetail.lastName)")
                                .bold()
                                .font(.headline)
                                .frame(maxWidth: .infinity,alignment: .leading)
                                .padding(.bottom,2)
                            
                            Text(viewModel.userDetail.email )
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
                        NavigationLink(destination: EditUserDetailView(userDetail: viewModel.userDetail), isActive: $isEditUserDetailViewActive){
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
            }
            .onAppear{
                viewModel.getUserDetails()
            }
        }detail: {
            Text("See more")
        }
    }
}

#Preview {
    MyProfileView()
}
