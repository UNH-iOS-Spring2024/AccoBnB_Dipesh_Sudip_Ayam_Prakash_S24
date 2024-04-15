
//
//  MapAnnotationItems.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 4/10/24.
//

import Foundation
import MapKit

struct MapAnnotationItems: Identifiable {
    let id = UUID()
    let text: String
    let lat: Double
    let long: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
}
