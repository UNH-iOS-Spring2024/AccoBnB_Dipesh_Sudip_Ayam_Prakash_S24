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
    @State private var isSettingsViewActive = false // Add this state
    
    var body: some View {
        NavigationSplitView{
            VStack {
                if userProfileVM.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }else{
                    ZStack {
                        VStack {
                            Rectangle()
                                .fill(Color("primaryColor").opacity(0.3))
                                .frame(width: UIScreen.main.bounds.width, height: 150)
                            Rectangle()
                                .fill(Color.white)
                                .frame(width: UIScreen.main.bounds.width, height: 50)
                        }
                        
                        VStack {
                            Image(systemName: "person")
                                .padding(35)
                                .background(Color("primaryColor"))
                                .foregroundColor(Color.white)
                                .font(.system(size: 30))
                                .clipShape(Circle())
                            Text("\(userProfileVM.userDetail.firstName) \(userProfileVM.userDetail.lastName)")
                                .bold()
                                .font(.largeTitle)
                                .frame(maxWidth: .infinity,alignment: .center)
                                .padding(.bottom,2)
                        }
                        .padding(.top, 120)
                    }.frame(width: UIScreen.main.bounds.width, height: 200)
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack {
                            Text("Email")
                                .foregroundColor(Color.gray)
                            
                            Spacer()
                            Text(userProfileVM.userDetail.email )
                        }                    .padding(.vertical, 5)
                        
                        HStack {
                            Text("Phone")
                                .foregroundColor(Color.gray)
                            
                            Spacer()
                            Text(userProfileVM.userDetail.phone.isEmpty ? "N/A" : userProfileVM.userDetail.phone)
                        }                    .padding(.vertical, 5)
                        
                    }
                    .padding(.horizontal, 30)
                    
                    
                    VStack{
                        Divider()
                        NavigationLink(destination: EditUserDetailView(userDetail: userProfileVM.userDetail), isActive: $isEditUserDetailViewActive){
                            BorderlessIconButtonView(buttonName: "Edit User Details", iconName: "person.crop.circle.badge.exclamationmark"){
                                isEditUserDetailViewActive = true
                            }
                        }
                        .navigationTitle("Profile")
                        Divider()

                        BorderlessIconButtonView(buttonName: "My Favorites", iconName: "heart.circle")
                        Divider()

                        BorderlessIconButtonView(buttonName: "My Bookings", iconName: "list.bullet.circle")
                        Divider()

                        NavigationLink(destination: SettingsView(), isActive: $isSettingsViewActive) {
                            BorderlessIconButtonView(buttonName: "Settings", iconName: "gearshape"){
                                isSettingsViewActive = true
                            }
                        }
                        .navigationTitle("Setting")
                        Divider()

                        BorderlessIconButtonView(buttonName: "Help", iconName: "phone.bubble")
                        Divider()

                    }
                    .padding(.vertical, 20)
                    
                    
                    CustomButtonView(buttonText: "Log Out"){
                        authVM.signOut()
                    }
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .padding(.top, 0)
            .onAppear{
                if(authVM.currentUser != nil){
                    userProfileVM.getUserDetails(userId: authVM.currentUser!.id)
                }
                
                userProfileVM.getUserDetails(userId: "xap9z81gb2XFsULfi5mAsvWme792")
            }
        }detail: {
            Text("See more")
        }
    }
}


struct MyProfileView_Previews: PreviewProvider {
    static var previews: some View {
        let userProfileViewModel = UserProfileViewModel()
        let authViewModel = AuthViewModel()
        MyProfileView()
            .environmentObject(userProfileViewModel)
            .environmentObject(authViewModel)
    }
}
