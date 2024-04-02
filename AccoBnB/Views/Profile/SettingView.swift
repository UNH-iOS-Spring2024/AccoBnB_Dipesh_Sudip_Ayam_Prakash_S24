//
//  SettingView.swift
//  AccoBnB
//
//  Created by Peter on 4/2/24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Form {
            
                Section(header: Text("Notification Settings")) {
                    Toggle("Push Notifications", isOn: .constant(true))
                    Toggle("Email Notifications", isOn: .constant(true))
                }
                
                Section(header: Text("App Settings")) {
                    Toggle("Dark Mode", isOn: .constant(false))
                    Toggle("Location Services", isOn: .constant(true))
                }
                
                Section(header: Text("About")) {
                    Text("Version 1.0")
                    Text("Privacy Policy")
                    Text("Terms & Conditions")
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
