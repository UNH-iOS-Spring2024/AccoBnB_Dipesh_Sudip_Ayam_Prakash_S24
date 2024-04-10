//
//  AddressSearchBarView.swift
//  AccoBnB
//
//  Created by AP on 03/04/2024.
//

import SwiftUI
import MapKit
import Combine

class SearchCompleterDelegateWrapper: ObservableObject {
    private let delegate: SearchCompleterDelegate
    
    @Published var searchResults: [MKLocalSearchCompletion] = []
    
    init() {
        delegate = SearchCompleterDelegate()
        delegate.delegateWrapper = self
    }
    
    func performSearch(for searchText: String) {
        delegate.performSearch(for: searchText)
    }
}

class SearchCompleterDelegate: NSObject, MKLocalSearchCompleterDelegate {
    weak var delegateWrapper: SearchCompleterDelegateWrapper?
    private let completer: MKLocalSearchCompleter
    
    override init() {
        self.completer = MKLocalSearchCompleter()
        super.init()
        self.completer.delegate = self
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        delegateWrapper?.searchResults = completer.results
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Handle search error if needed
    }
    
    func performSearch(for searchText: String) {
        completer.queryFragment = searchText
    }
}


struct AddressSearchBarView: View {
    @State private var searchText = ""
    @StateObject private var completerDelegateWrapper = SearchCompleterDelegateWrapper()
    @State private var isListVisible = true // Track list visibility
    var didSelectLocation: ((MKLocalSearchCompletion) -> Void)?
    
    var body: some View {
        
        NavigationStack {
            List(completerDelegateWrapper.searchResults, id: \.self) { location in
                Button(action: {
                    didSelectLocation?(location)
                    withAnimation {
                        isListVisible = false
                    }
                }) {
                    VStack(alignment: .leading) {
                        Text(location.title)
                        Text(location.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .opacity(isListVisible ? 1 : 0)                    
            .navigationTitle("Search Location")
        }
        .searchable(text: $searchText)
        .onChange(of: searchText) { completerDelegateWrapper.performSearch(for: searchText) }
    }
    
}


struct AddressSearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        AddressSearchBarView()
    }
}
