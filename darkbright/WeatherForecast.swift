//
//  WeatherForecast.swift
//  darkbright
//
//  Created by Pierre Enriquez on 5/2/17.
//  Copyright © 2017 Three One Four. All rights reserved.
//

import UIKit
import Alamofire

class WeatherForecast {
    private var _latitude: Double!
    private var _longitude: Double!
    private var _timezone: String!
    private var _date: Date!
    private var _summary: String!
    private var _icon: String!
    private var _temperature: Double!
    private var _forecasts = [Forecast]()
    
    var date: String {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        df.timeZone = TimeZone(identifier: _timezone)
        let dateString = "Today, \(df.string(from: _date))"
        return dateString
    }
    
    var summary: String {
        return _summary
    }
    
    var icon: String {
        return _icon
    }
    
    var temperature: Double {
        return _temperature
    }
    
    var temperatureDegrees: String {
        let degrees = "\(self.temperature)°"
        return degrees
    }
    
    var isDaytime: Bool {
        return _date.isDaytime()
    }
    
    var forecasts: [Forecast] {
        return _forecasts
    }
    
    private init() {
        // Do nothing
    }
    
    class func downloadFor(latitude: Double, longitude: Double, completed: @escaping (WeatherForecast?) -> ()) {
        let url = "\(BASE_URL)/\(ENDPOINT)/\(API_KEY)/\(latitude),\(longitude)?\(OPTIONALS)"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                let wf = WeatherForecast()
                let result = response.result
                if let dict = result.value as? Dictionary<String, AnyObject> {
                    if let lat = dict["latitude"] as? Double {
                        wf._latitude = lat
                    }
                    
                    if let lon = dict["longitude"] as? Double {
                        wf._longitude = lon
                    }
                    
                    if let tz = dict["timezone"] as? String {
                        wf._timezone = tz
                    }
                    
                    if let currently = dict["currently"] as? Dictionary<String, AnyObject> {
                        if let time = currently["time"] as? Double {
                            wf._date = Date(timeIntervalSince1970: time)
                        }
                        
                        if let summary = currently["summary"] as? String {
                            wf._summary = summary
                        }
                        
                        if let icon = currently["icon"] as? String {
                            wf._icon = icon
                        }
                        
                        if let temperature = currently["temperature"] as? Double {
                            wf._temperature = temperature
                        }
                    }
                    
                    if let daily = dict["daily"] as? Dictionary<String, AnyObject> {
                        if let data = daily["data"] as? [Dictionary<String, AnyObject>] {
                            for object in data {
                                let forecast = Forecast(forecast: object)
                                forecast.timezone = wf._timezone
                                wf._forecasts.append(forecast)
                            }
                            
                            wf._forecasts.removeFirst()
                        }
                    }
                    
                    completed(wf)
                } else {
                    completed(nil);
                }
                
            case .failure:
                completed(nil);
            }
        }
    }
}
