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
    @State private var selectedPhoto: UIImage?
    @State private var isShowingImagePicker = false // Control showing the image picker
    @State private var isShowingCamera = false // Control showing the camera
    var body: some View {
        Spacer()
        VStack{
            Image(uiImage: selectedPhoto ?? UIImage(systemName: "person")!)
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
                    await userProfileVM.updateUserDetail(userDetail: userDetail)
                }
                // This is an Environment object that is declared to stack back to parent
                dismiss()
            }
            .padding(.top, 8)
        }
        .onAppear{
            if let url = URL(string: userDetail.profileImage){
                let imageData = try! Data(contentsOf: url)
                selectedPhoto = UIImage(data: imageData)
            }
        }
        
        Spacer()
    }
}

#Preview {
    EditUserDetailView(userDetail: User.defaultUser)
}
