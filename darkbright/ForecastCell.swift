//
//  ForecastCell.swift
//  darkbright
//
//  Created by Pierre Enriquez on 5/2/17.
//  Copyright © 2017 Three One Four. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var hiLowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 1;
        self.layer.shadowOpacity = 1.0;
    }
    
    func configure(forecast: Forecast) {
        dateLabel.text = forecast.date
        weatherIcon.image = UIImage(named: forecast.icon)
        hiLowLabel.text = forecast.hiLowTemperature
    }
}
