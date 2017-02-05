//
//  Forecast.swift
//  darkbright
//
//  Created by Pierre Enriquez on 5/2/17.
//  Copyright © 2017 Three One Four. All rights reserved.
//

import Foundation

class Forecast {
    private var _date: Date?
    private var _summary: String?
    private var _icon: String?
    private var _minTemp: Double?
    private var _maxTemp: Double?
    
    private var _timezone: String?
    
    var timezone: String {
        get {
            if _timezone == nil {
                _timezone = ""
            }
            return _timezone!
        }
        set {
            _timezone = newValue
        }
    }
    
    var date: String {
        if _date == nil {
            _date = Date()
        }
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        if let empty = _timezone?.isEmpty {
            if !empty {
                df.timeZone = TimeZone(identifier: _timezone!)
            }
        }
        let dateString = "\(_date!.dayOfTheWeek()), \(df.string(from: _date!))"
        return dateString
    }
    
    var summary: String {
        if _summary == nil {
            _summary = ""
        }
        
        return _summary!
    }
    
    var icon: String {
        if _icon == nil {
            _icon = "clear-day"
        }
        
        return _icon!
    }
    
    var minimumTemperature: Double {
        if _minTemp == nil {
            _minTemp = 0.0
        }
        
        return _minTemp!
    }
    
    var maximumTemperature: Double {
        if _maxTemp == nil {
            _maxTemp = 100.0
        }
        
        return _maxTemp!
    }
    
    init(forecast: Dictionary<String, AnyObject>) {
        if let time = forecast["time"] as? Double {
            self._date = Date(timeIntervalSince1970: time)
        }
        
        if let summary = forecast["summary"] as? String {
            self._summary = summary
        }
        
        if let icon = forecast["icon"] as? String {
            self._icon = icon
        }
        
        if let minTemp = forecast["temperatureMin"] as? Double {
            self._minTemp = minTemp
        }
        
        if let maxTemp = forecast["temperatureMax"] as? Double {
            self._maxTemp = maxTemp
        }
    }
}
