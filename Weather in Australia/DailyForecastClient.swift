//
//  DailyForecastClient.swift
//  Weather in Australia
//
//  Created by David Ye on 26/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

class DailyForecastClient{
    // MARK: - properties
    private let urlString : String
    private let appID : String
    private let units : Units
    
    // MARK: - constructor. appID for consuming OpenWeatherMap webservice
    init(urlString : String, appID : String, units : Units){
        self.urlString = urlString
        self.appID = appID
        self.units = units
    }
    
    func requestDailyWeatherForecast(city : City, days : Int, onComplete complete: @escaping (NSDictionary?)->()){
        //http://api.openweathermap.org/data/2.5/forecast/daily?q=London&units=metric&cnt=1&appid=3fe25736cbd429e82dd9abb3afca0002
        let connectionString = String(format: "\(urlString)q=\(city.name!),\(city.country!.countryCode)&units=\(units.rawValue)&APPID=\(appID)")
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let weatherData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary{
                        print(weatherData)
                        complete(weatherData as NSDictionary)
                    }
                }
            }else{
                print(error!)
            }
            complete(nil)
        }.resume()
    }
}
