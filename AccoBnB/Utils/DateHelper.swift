//
//  DateHelper.swift
//  AccoBnB
//
//  Created by Sudip Thapa on 4/10/24.
//

import Foundation

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    func formattedDateToString() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd MMMM yyyy"
          return dateFormatter.string(from: self)
      }
    func formattedDateTimeToString() -> String {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "dd MMMM yyyy hh:mm a"
          return dateFormatter.string(from: self)
      }
}
