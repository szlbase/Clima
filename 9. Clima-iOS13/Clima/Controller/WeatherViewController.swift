//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTxtField: UITextField!
    
    var weatherMgr = WeatherManager()
    var locationMgr = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationMgr.delegate = self
        locationMgr.requestWhenInUseAuthorization()
        locationMgr.requestLocation()
        
        searchTxtField.delegate = self
        weatherMgr.delegate = self
    }

    @IBAction func searchBtnPressed(_ sender: UIButton) {
        searchTxtField.endEditing(true)
    }
    
    @IBAction func currentLocationBtnPressed(_ sender: UIButton) {
        locationMgr.requestLocation()
    }
}

//MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTxtField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text {
            weatherMgr.fetchWeather(city: city)
        }
        searchTxtField.text = ""
    }
}

//MARK: WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherMgr: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.tempString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityBame
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            weatherMgr.fetchWeather(latitude: lat, longitude: long)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
