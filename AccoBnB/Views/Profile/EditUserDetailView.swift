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
            // Load image from URL using AsyncImage
            if let url = URL(string: userDetail.profileImage) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 200)
                    case .failure:
                        Image(systemName: "person")
                            .resizable()
                            .frame(width: 200, height: 200)
                    @unknown default:
                        EmptyView()
                    }
                }
                .foregroundColor(Color.gray)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .padding(.bottom, 20)
                .overlay(alignment: .center) {
                    Button {
                        isShowingImagePicker.toggle()
                    } label: {
                        Image(systemName: "pencil.circle.fill")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 30))
                            .foregroundColor(.accentColor)
                    }
                }
                .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                    isShowingImagePicker = false
                }, content: {
                    ImagePicker(selectedImage: $selectedPhoto, isShowingImagePicker: $isShowingImagePicker, isShowingCamera: $isShowingCamera)
                })
            } else {
                // Use a placeholder if the URL is invalid
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .background(Color.gray)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 20)
                    .overlay(alignment: .center) {
                        Button {
                            isShowingImagePicker.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .symbolRenderingMode(.multicolor)
                                .font(.system(size: 30))
                                .foregroundColor(.accentColor)
                        }
                    }
                    .sheet(isPresented: $isShowingImagePicker, onDismiss: {
                        isShowingImagePicker = false
                    }, content: {
                        ImagePicker(selectedImage: $selectedPhoto, isShowingImagePicker: $isShowingImagePicker, isShowingCamera: $isShowingCamera)
                    })
            }
            
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
        Spacer()
    }
}

#Preview {
    EditUserDetailView(userDetail: User(id: "HTBPM53yGJalG6JpB4wuQmVYKGx1",firstName: "Dipesh", lastName: "Shrestha", phone: "0000000000", profileImage: "https://dfstudio-d420.kxcdn.com/wordpress/wp-content/uploads/2019/06/digital_camera_photo-1080x675.jpg", email: "dipesh@gmail.com"))
}
