//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by Manish sahu on 31/05/25.
//

import Foundation

extension Date {
    func convertToMonthYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
     
        return dateFormatter.string(from: self)
    }
}
