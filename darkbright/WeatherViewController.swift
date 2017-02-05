//
//  ViewController.swift
//  darkbright
//
//  Created by Pierre Enriquez on 4/2/17.
//  Copyright © 2017 Three One Four. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherType: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var forecastTable: UITableView!
    
    private let _locationManager = CLLocationManager()
    private var _currentLocation: CLLocation!
    
    private var _weatherForecast: WeatherForecast?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _locationAuthorizationStatus()
        
        forecastTable.delegate = self
        forecastTable.dataSource = self        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.forecastTable.backgroundColor = .clear
        self.forecastTable.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let forecasts = _weatherForecast?.forecasts {
            return forecasts.count > 5 ? 5 : forecasts.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = forecastTable.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastCell {
            cell.configure(forecast: _weatherForecast!.forecasts[indexPath.row])
            return cell
        }
        return ForecastCell()
    }
        
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if let currentLocation = manager.location {
                WeatherForecast.downloadFor(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude) { weatherForecast in
                    self._weatherForecast = weatherForecast
                    if let wf = self._weatherForecast {
                        self.temperature.text = wf.temperatureDegrees
                        self.weatherIcon.image = UIImage(named: wf.icon)
                        self.dateLabel.text = wf.date
                        self.weatherType.text = wf.summary
                        
                        self._getLocation(currentLocation) { locality in
                            self.location.text = locality
                        }
                        
                        self.forecastTable.reloadData()
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _locationManager.stopUpdatingLocation()
    }
    
    private func _locationAuthorizationStatus() {
        _locationManager.delegate = self

        let status  = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            _locationManager.requestWhenInUseAuthorization()
            _locationManager.startUpdatingLocation()
            return
        }
        
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            
            present(alert, animated: true, completion: nil)
            return
        }
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.requestWhenInUseAuthorization()
        _locationManager.startUpdatingLocation()
    }
    
    private func _getLocation(_ location: CLLocation, completed: @escaping (String) -> ()) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let pms = placemarks {
                if error != nil {
                    completed("Unknown")
                    return
                }
                
                if pms.count > 0 {
                    if let locality = pms.first?.locality {
                        completed(locality)
                        return
                    }
                }
                
                completed("Unknown")
            }
        }
    }
}

