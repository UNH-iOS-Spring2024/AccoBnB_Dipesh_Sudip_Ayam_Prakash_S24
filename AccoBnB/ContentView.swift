//
//  ContentView.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userStateVM: UserStateViewModel
    var body: some View {
        VStack {
            MenuNavigationView()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
