//
//  WeatherForecastLoader.swift
//  Lesson 14
//
//  Created by Maxim Gorin on 03.02.2021.
//

import Foundation
import Alamofire
import SVProgressHUD

class WeatherForecastLoader {
    private let host = "https://api.openweathermap.org/data/2.5/"
    private let key = "abcd6e791bf67b163bf575241ab7bd0d"
    private let units = "metric"
    private let lang = "ru"
    private let exclude = "current,minutely,hourly,alerts"

    private var todayUrl: String {
        get {
            host + "weather?q=Moscow&appid=" + key + "&units=" + units + "&lang=" + lang
        }
    }
    
    private var forecast16Url: String {
        get {
            host + "onecall?lat=55.7522&lon=37.6156&exclude=" + exclude + "&appid=" + key + "&units=" + units + "&lang=" + lang
        }
    }
    
    //    MARK: - Alamofire
    func loadCurrentWeatherViaAlamofire(showLoader: Bool, completion: @escaping (Forecast?) -> Void) {
        if showLoader { SVProgressHUD.show() }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let url = URL(string: self.todayUrl) {

                AF.request(url).responseJSON { response in
                    if let objects = response.value,
                       let jsonDict = objects as? NSDictionary {
                        let forecast = Forecast(jsonDict)
                        
                        UserDefaultsPersistance.shared.forecast = jsonDict
                        
                        if showLoader { SVProgressHUD.dismiss() }
                        completion(forecast)
                    } else {
                        if showLoader { SVProgressHUD.dismiss() }
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func loadWeather16ViaAlamofire(showLoader: Bool, completion: @escaping (Daily?) -> Void) {
        if showLoader { SVProgressHUD.show() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let url = URL(string: self.forecast16Url) {
                var req = URLRequest(url: url)
                req.httpMethod = "GET"
                req.setValue("application/json", forHTTPHeaderField: "Content-Type")
                req.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

                AF.request(req).responseJSON { response in
                    if let objects = response.value,
                       let jsonDict = objects as? NSDictionary {
                        let daily = Daily(jsonDict)
                        
                        UserDefaultsPersistance.shared.daily = jsonDict
                        
                        if showLoader { SVProgressHUD.dismiss() }
                        completion(daily)
                    } else {
                        if showLoader { SVProgressHUD.dismiss() }
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}
