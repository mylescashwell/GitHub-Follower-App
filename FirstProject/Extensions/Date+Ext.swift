//
//  Date+Ext.swift
//  FirstProject
//
//  Created by Myles Cashwell on 10/28/20.
//  Copyright © 2020 Myles Cashwell. All rights reserved.
//

import Foundation

extension Date {
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM, yyyy"
        
        return dateFormatter.string(from: self)
        // returns date format found in dateFormatter.dateFormat string
    }
    
}
