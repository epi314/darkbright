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
        df.dateFormat = "EEEE"
        return df.string(from: self)
    }
}
