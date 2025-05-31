//
//  String+Ext.swift
//  GHFollowers
//
//  Created by Manish sahu on 31/05/25.
//

import Foundation

extension String {
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
         
        return dateFormatter.date(from: self)
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = convertToDate() else {
            return "N/A"
        }
        
        return date.convertToMonthYear()
    }
}
