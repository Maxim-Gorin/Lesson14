//
//  WeatherView.swift
//  Lesson 14
//
//  Created by Maxim Gorin on 03.02.2021.
//

import UIKit

class WeatherView: UIView {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var tempMinLabel: UILabel!
    @IBOutlet weak var tempMaxLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!

    class func instanceFromNib() -> UIView {
        return UINib(nibName: "WeatherView", bundle: nil).instantiate(withOwner: nil, options: nil).first  as! UIView
    }
}
