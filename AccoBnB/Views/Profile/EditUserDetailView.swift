//
//  EditUserDetailView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/18/24.
//

import SwiftUI

struct EditUserDetailView: View {
    @ObservedObject private var userProfileVM = UserProfileViewModel()
    @Environment(\.dismiss) var dismiss // used to stack back to parent screen
    @State var userDetail: User
    @State private var isNewImageSelected = false
    @State private var userPhoto: UIImage?
    @State private var selectedPhoto: UIImage?
    @State private var isShowingImagePicker = false // Control showing the image picker
    @State private var isShowingCamera = false // Control showing the camera
    var body: some View {
        Spacer()
        if userProfileVM.isLoading {
            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle())
                .padding()
        }else {
            VStack{
                Image(uiImage: selectedPhoto ?? userPhoto ?? UIImage(systemName: "person")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .background(Color.gray)
                    .clipShape(Circle())
                    .overlay(alignment: .centerFirstTextBaseline) {
                        Button {
                            isShowingImagePicker.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 50))
                                .foregroundColor(.accentColor)
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                        isShowingImagePicker = false
                    }) {
                        ImagePicker(selectedImage: $selectedPhoto, isShowingImagePicker: $isShowingImagePicker, isShowingCamera: $isShowingCamera)
                    }
                    .padding(.bottom, 20)
                
                
                CustomTextFieldView(placeholder: "First Name", text: $userDetail.firstName, isSecureField: false)
                CustomTextFieldView(placeholder: "Last Name" , text: $userDetail.lastName, isSecureField: false)
                CustomTextFieldView(placeholder: "Email",text: $userDetail.email, isSecureField: false, isDisabled: true)
                    .foregroundColor(Color.gray)
                CustomTextFieldView(placeholder: "Phone Number", text: $userDetail.phone, isSecureField: false)
                
                CustomButtonView(buttonText: "Update"){
                    Task{
                        await userProfileVM.updateUserDetail(userImage: selectedPhoto, userDetail: userDetail)
                        dismiss()
                    }
                   
                }
                .padding(.top, 8)
            }
            .onAppear{
                if let url = URL(string: userDetail.profileImage){
                    let imageData = try! Data(contentsOf: url)
                    userPhoto = UIImage(data: imageData)
                }
            }
        }
        
        
        Spacer()
    }
}

#Preview {
    EditUserDetailView(userDetail: User.defaultHostUser)
}
