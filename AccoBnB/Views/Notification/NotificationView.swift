//
//  NotificationView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/25/24.
//

import SwiftUI

struct NotificationView: View {
    @EnvironmentObject var notificationViewModel: NotificationViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationSplitView {
            VStack {
                if notificationViewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    List {
                        ForEach(notificationViewModel.notifications, id: \.self) { notification in
                            HStack {
                                Image(systemName: "bell.circle")
                                    .font(.system(size: 30, weight: .light))
                                    .foregroundStyle(.secondary)
                                VStack(alignment: .leading) {
                                    Text(notification.message)
                                        .font(.system(size: 14))
                                    Text(notification.createdAt!.timeAgoDisplay())
                                        .font(.system(size: 10))
                                        .foregroundStyle(.secondary)
                                }
                                
                            }
                            .frame(width: .infinity, height: .infinity)
                            .padding(.vertical, 2)
                        }
                        
                    }.navigationTitle("Notifications")
                        .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                if((authViewModel.currentUser?.id) != nil){
                    notificationViewModel.getNotifications(userId: "xap9z81gb2XFsULfi5mAsvWme792")
                }
                notificationViewModel.getNotifications(userId: "xap9z81gb2XFsULfi5mAsvWme792")

            }
        } detail: {
            EmptyView()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        let notificationViewModel = NotificationViewModel()
        let authViewModel = AuthViewModel()
        NotificationView()
            .environmentObject(notificationViewModel)
            .environmentObject(authViewModel)
    }
}

