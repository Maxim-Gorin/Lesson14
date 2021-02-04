//
//  ForecastModel.swift
//  Lesson 12
//
//  Created by Maxim Gorin on 02.02.2021.
//

import Foundation

// common models
struct Weather {
    let main: String
    let description: String
    
    init(_ dict: Dictionary<String, Any>) {
        self.description = dict["description"] as! String
        self.main = dict["main"] as! String
    }
}

struct Weathers {
    let weathers: [Weather]
    
    init(_ array: Array<Any>) {
        var weathers = [Weather]()
        for item in array {
            weathers.append(Weather(item as! Dictionary<String, Any>))
        }
        self.weathers = weathers
    }
}

// models for current forcast
struct Forecast {
    let main: Main
    let weather: Weathers
    let town: String
    
    init(_ dict: NSDictionary) {
        self.main = Main(dict["main"] as! Dictionary)
        self.weather = Weathers(dict["weather"] as! Array<Any>)
        self.town = dict["name"] as! String
    }
}

struct Main {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
    
    init(_ dict: Dictionary<String, Double>) {
        self.temp = dict["temp"]!
        self.feelsLike = dict["feels_like"]!
        self.tempMin = dict["temp_min"]!
        self.tempMax = dict["temp_max"]!
        self.humidity = dict["humidity"]!
    }
}

// models for few days
struct Daily {
    let daily: DailyForecasts

    init(_ dict: NSDictionary) {
        self.daily = DailyForecasts(dict["daily"] as! Array<Any>)
    }
}

struct DailyForecasts {
    let dailyForcasts: [DailyForecast]

    init(_ array: Array<Any>) {
        var dailyForcast = [DailyForecast]()
        for item in array {
            dailyForcast.append(DailyForecast(item as! Dictionary<String, Any>))
        }
        self.dailyForcasts = dailyForcast
    }
}

struct DailyForecast {
    let temp: Temp
    let weather: Weathers
    private let date: Date
    var dateStr: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            return dateFormatter.string(from: date)
        }
    }

    init(_ dict: Dictionary<String, Any>) {
        self.date = Date(timeIntervalSince1970: dict["dt"] as! TimeInterval)
        self.temp = Temp(dict["temp"] as! Dictionary<String, Any>)
        self.weather = Weathers(dict["weather"] as! Array<Any>)
    }
}

struct Temp {
    let dayTemp: Double
    let nightTemp: Double

    init(_ dict: Dictionary<String, Any>) {
        self.dayTemp = dict["day"] as! Double
        self.nightTemp = dict["night"] as! Double
    }
}
