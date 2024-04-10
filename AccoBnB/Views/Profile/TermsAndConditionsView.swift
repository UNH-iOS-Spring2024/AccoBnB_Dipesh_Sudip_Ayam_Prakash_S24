//
//  TermsAndConditionsView.swift
//  AccoBnB
//
//  Created by Peter on 4/7/24.
//

import SwiftUI

struct TermsAndConditionsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 23) {
        
                Text("By accessing and using this app, you agree to be bound by the following terms and conditions:")
                
                Text("1. You must be at least 18 years old to use this app.")
                
                Text("2. The content provided by this app is for informational purposes only.")
                
                Text("3. We do not guarantee the accuracy, completeness, or reliability of any information or content provided.")
                
                Text("4. Your use of this app is at your own risk. We are not liable for any damages or losses arising from your use of this app.")
                
                Text("5. We reserve the right to modify or discontinue any feature or service offered through this app at any time without notice.")
                
                Text("6. Your use of this app constitutes acceptance of these terms and conditions.")
            }
            .padding(25)
        }
        .navigationBarTitle("Terms and Conditions")
    }
}

struct TermsAndConditionsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditionsView()
    }
}
