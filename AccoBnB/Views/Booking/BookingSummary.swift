//
//  BookingSummary.swift
//  AccoBnB
//
//  Created by Dipesh Shrestha on 3/30/24.
//

import SwiftUI
import MapKit

struct BookingSummary: View {
    @State var bookingDetail: Booking
    @State var region: MKCoordinateRegion
    @State private var isBottomSheetViewEnabled: Bool = false
    @EnvironmentObject var reviewViewModel: ReviewViewModel
    
    @State var isReviewedAlready: Bool = false
    
     private var formattedBookingDetails: [String:Any] = [:]
    
    init(bookingDetail: Booking) {
        self._bookingDetail = State(initialValue: bookingDetail)
        
        let center = CLLocationCoordinate2D(
            latitude: Double(bookingDetail.listingInfo?.geoLocation?.lat ?? "0.0")!,
            longitude: Double(bookingDetail.listingInfo?.geoLocation?.long ?? "0.0")!)
        self._region = State(initialValue: MKCoordinateRegion(
            center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
        
        // converting Date to String type
         let date = self.bookingDetail.createdAt ?? Date()
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "MM/dd/YYYY HH:MM"
         let formattedCreatedAt = dateFormatter.string(from: date)
         self.formattedBookingDetails["createdAt"] = formattedCreatedAt
    }
    var body: some View {
        VStack(alignment: .leading){
            List {
                Section("Location"){
                    Map(coordinateRegion: $region, interactionModes: [.pan, .zoom])
                        .listRowInsets(EdgeInsets())
                        .frame(width: 400, height: 200)
                }
                Section("Booking Information"){
                    HStack{
                        Text("Booking Status:")
                            .foregroundStyle(Color.gray)
                            .bold()
                        Spacer()
                        Text(bookingDetail.status.rawValue)
                    }
                    HStack{
                        Text("Booked on:")
                            .foregroundStyle(Color.gray)
                            .bold()
                        Spacer()
                        Text(formattedBookingDetails["createdAt"] as? String ?? "")
                    }
                    HStack{
                        Text("Total Amount:").foregroundStyle(Color.gray)
                            .bold()
                        Spacer()
                        Text(bookingDetail.totalAmount as? String ?? "0.0")
                    }
                    HStack{
                        Text("Booking Note:").foregroundStyle(Color.gray)
                            .bold()
                        Spacer()
                        Text(bookingDetail.bookingNote)
                    }
                }
            }
            
            CustomButtonView(buttonText: "Review your Booking"){
                self.isBottomSheetViewEnabled = true
            }
            .disabled(isReviewedAlready)
            
            if isBottomSheetViewEnabled{
                BottomSheetView(isPresented: $isBottomSheetViewEnabled, viewTitle: "Write a review", isRatingViewDisabled: false) { review, rating in
//                    print("TODO: update review to database \(review) \(rating)")
                    Task {
                        try await reviewViewModel.createUserReview(reviewerId: bookingDetail.userId, listingId: bookingDetail.listingId, rating: Float(rating!), comment: review, date: Date())
                    }
                    isReviewedAlready = true
                }
            }
        }
    }
}

#Preview {
    BookingSummary(bookingDetail: Booking())
}
