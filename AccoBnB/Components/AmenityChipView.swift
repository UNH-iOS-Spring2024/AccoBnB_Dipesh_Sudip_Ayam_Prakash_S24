//
//  AmenityChipView.swift
//  AccoBnB
//
//  Created by AP on 02/04/2024.
//
import SwiftUI

struct AmenityChipView: View {
    let amenity: Amenity
    @Binding var selectedAmenities: Set<Amenity>
    
    var body: some View {
        
        Button(action: {
            if selectedAmenities.contains(amenity) {
                selectedAmenities.remove(amenity)
            } else {
                selectedAmenities.insert(amenity)
            }
        }) {
            HStack {
                amenity.icon
                    .foregroundColor(Color("primaryColor"))
                    .font(.system(size: 15))
                Text(amenity.rawValue)
            }
            .foregroundColor(selectedAmenities.contains(amenity) ? .white : .black)
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .background(selectedAmenities.contains(amenity) ? Color.blue : Color.gray.opacity(0.3))
            .cornerRadius(20)
        }
    }
}

struct AmenityChipView_Previews: PreviewProvider {
    static var previews: some View {
        let selectedAmenities: Set<Amenity> = []
        AmenityChipView(amenity: .wifi, selectedAmenities: .constant(selectedAmenities))
    }
}



