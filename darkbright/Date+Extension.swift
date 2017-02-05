//
//  Date+DayOfWeek.swift
//  darkbright
//
//  Created by Pierre Enriquez on 5/2/17.
//  Copyright © 2017 Three One Four. All rights reserved.
//

import Foundation

extension Date {
    func dayOfTheWeek() -> String {
        let df = DateFormatter()
        df.dateFormat = "EEE"
        return df.string(from: self)
    }
    
    func isDaytime() -> Bool {
        let df = DateFormatter()
        df.dateFormat = "HHmm"
        if let time = Int(df.string(from: self)) {
            if time >= 600 && time < 1800 {
                return true
            }
        }
        
        return false
    }
}
