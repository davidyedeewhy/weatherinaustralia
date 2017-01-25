//
//  WeatherConditionClient.swift
//  Weather in Australia
//
//  Created by David Ye on 25/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

class WeatherConditionClient{

    // MARK: - request weather icon, no appID required
    func requestWeatherIcon(iconID: String, onComplete complete: @escaping (Data?)->()){
        let connectionString = String(format: "http://openweathermap.org/img/w/\(iconID).png")
        print(connectionString)
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var icon : Data?
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    icon = data
                }
            }else{
                print(error!)
            }
            complete(icon)
        }.resume()
    }
}
