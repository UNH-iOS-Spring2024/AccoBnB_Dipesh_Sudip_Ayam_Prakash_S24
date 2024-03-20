//
//  SearchBarView.swift
//  AccoBnB
//
//  Created by Peter on 3/19/24.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(8)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)

            Button(action: {
                searchText = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
            }
            .opacity(searchText.isEmpty ? 0 : 2) // Changed opacity condition
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
    }
}
