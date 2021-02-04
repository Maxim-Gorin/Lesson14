//
//  WeatherViewController.swift
//  Lesson 14
//
//  Created by Maxim Gorin on 03.02.2021.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var todayView: UIView!
    @IBOutlet weak var weekView: UIView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var todaySubview = WeatherView()
    
    private var daily: Daily?
    private var forecast: Forecast?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")

        todaySubview = WeatherView.instanceFromNib() as! WeatherView

        // Do any additional setup after loading the view.
        
        if let dailyDict = UserDefaultsPersistance.shared.daily, let forecastDict = UserDefaultsPersistance.shared.forecast {
            daily = Daily(dailyDict)
            forecast = Forecast(forecastDict)
        }
                
        if !showLoader() {
            activityIndicator.startAnimating()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let forecast = forecast, !showLoader() {
            fillingFields(forecast)
        }
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadForecastForTodayAlamofire()
        loadForecastFor16DaysAlamofire()
    }
        
    // MARK: - Alamofire
    func loadForecastForTodayAlamofire() {
        let loader = WeatherForecastLoader()
        loader.loadCurrentWeatherViaAlamofire(showLoader: showLoader()) { [weak self] response in
            guard let forecast = response else {
                return
            }
            
            self?.fillingFields(forecast)
        }
    }
    
    func loadForecastFor16DaysAlamofire() {
        let loader = WeatherForecastLoader()
        loader.loadWeather16ViaAlamofire(showLoader: showLoader()) { response in
            guard let daily = response else {
                return
            }
            
            DispatchQueue.main.async {
                self.daily = daily
                
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func showLoader() -> Bool {
        daily == nil || forecast == nil
    }
    
    //MARK: - filling in the fields
    func fillingFields(_ forecast: Forecast) {
        DispatchQueue.main.async {
            self.todaySubview.frame = CGRect(origin: .zero, size: self.todayView.frame.size)
            self.todayView.addSubview(self.todaySubview)

            self.todaySubview.dayLabel.text = "Today"
            self.todaySubview.locationLabel.text = forecast.town
            
            self.todaySubview.tempLabel.text = String(format:"%.f °C", forecast.main.temp)
            self.todaySubview.feelsLikeLabel.text = String(format:"%.f °C", forecast.main.feelsLike)
            self.todaySubview.tempMinLabel.text = String(format:"%.f °C", forecast.main.tempMin)
            self.todaySubview.tempMaxLabel.text = String(format:"%.f °C", forecast.main.tempMax)
            self.todaySubview.humidityLabel.text = String(format:"%.f", forecast.main.humidity) + " %"
        }
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daily?.daily.dailyForcasts.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? TableViewCell, let daily = daily {
            let forecast = daily.daily.dailyForcasts[indexPath.row]
            
            cell.dateLabel.text = forecast.dateStr
            cell.dayTempLabel.text = String(format:"%.f °C", forecast.temp.dayTemp)
            cell.nightTempLabel.text = String(format:"%.f °C", forecast.temp.nightTemp)

            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

