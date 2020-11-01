//
//  String+Ext.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/28/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import Foundation

extension String {
    
    func convertToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale     = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone   = .current
        
        
        return dateFormatter.date(from: self)
        // .date is optional
        // if date from user.createdAt doesn't match exact dateFormatter.dateFormat String, function returning Date? will return nil
    }
    
    func convertToDisplayFormat() -> String {
        guard let date = self.convertToDate() else {return "Beginning Date Not Available"}
        // check for matching date format in convertToDate
        // if Date? returns nil, return this String
        
        return date.convertToMonthYearFormat()
        // if Date? matches format, convert from that format to format found in Date extension
        
    }
    
}
