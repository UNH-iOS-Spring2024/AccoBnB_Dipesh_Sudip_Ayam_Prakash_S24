//
//  PrivacyPolicyView.swift
//  AccoBnB
//
//  Created by Peter on 4/6/24.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 23) {                
                Text("Your privacy is important to us. It is our policy to respect your privacy regarding any information we may collect from you across our app.")
                
                Text("We only ask for personal information when we truly need it to provide a service to you. We collect it by fair and lawful means, with your knowledge and consent. We also let you know why we’re collecting it and how it will be used.")
                
                Text("We only retain collected information for as long as necessary to provide you with your requested service. What data we store, we’ll protect within commercially acceptable means to prevent loss and theft, as well as unauthorized access, disclosure, copying, use or modification.")
                
                Text("We don’t share any personally identifying information publicly or with third-parties, except when required to by law.")
                
                Text("Our app may link to external sites that are not operated by us. Please be aware that we have no control over the content and practices of these sites, and cannot accept responsibility or liability for their respective privacy policies.")
                
                Text("You are free to refuse our request for your personal information, with the understanding that we may be unable to provide you with some of your desired services.")
                
                Text("Your continued use of our app will be regarded as acceptance of our practices around privacy and personal information. If you have any questions about how we handle user data and personal information, feel free to contact us.")
            }
            .padding(25)
        }
        .navigationBarTitle("Privacy Policy")
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
