//
//  MapSearchTextFieldView.swift
//  AccoBnB
//
//  Created by AP on 03/04/2024.
//
import SwiftUI
import MapKit

struct MapSearchTextFieldView: UIViewRepresentable {
    @Binding var searchText: String
    var onSearch: ([MKMapItem]) -> Void

    class Coordinator: NSObject, UISearchBarDelegate {
        var parent: MapSearchTextFieldView

        init(parent: MapSearchTextFieldView) {
            self.parent = parent
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            parent.searchText = searchText
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = searchText
            let search = MKLocalSearch(request: searchRequest)
            search.start { response, error in
                guard let response = response else {
                    print("Error searching for places: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.parent.onSearch(response.mapItems)
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchText
    }
}
