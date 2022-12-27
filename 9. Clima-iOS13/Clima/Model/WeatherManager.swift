//
//  WeatherManager.swift
//  Clima
//
//  Created by LIN SHI ZHENG on 13/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherMgr: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=0cbdab01eb97687b71da80356257fe0b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String) {
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //create url
        if let url = URL(string: urlString) {
            
            //create session
            let session = URLSession(configuration: .default)
            
            //assign task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let data = data {
                    if let weather = self.parseJSON(data: data) {
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //start task
            task.resume()
        }
    }
    
    func parseJSON(data: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: data)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            return WeatherModel(conditionId: id, cityBame: name, temp: temp)
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
