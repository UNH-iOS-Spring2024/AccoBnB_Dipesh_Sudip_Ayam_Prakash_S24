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
                            Text(notification.message)
                            
                        }
                        
                    }.navigationTitle("Notifications")
                        .listStyle(PlainListStyle())
                }
            }
            .onAppear {
                if((authViewModel.currentUser?.id) != nil){
                    notificationViewModel.getNotifications(userId: authViewModel.currentUser!.id)
                }
      
            }
        } detail: {
            EmptyView()
        }
    }
}

#Preview {
    NotificationView()
}
