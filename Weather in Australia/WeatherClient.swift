
//
//  WeatherClient.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//


//coord
//coord.lon City geo location, longitude
//coord.lat City geo location, latitude
//weather (more info Weather condition codes)
//weather.id Weather condition id
//weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
//weather.description Weather condition within the group
//weather.icon Weather icon id
//base Internal parameter
//main
//main.temp Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
//main.pressure Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
//main.humidity Humidity, %
//main.temp_min Minimum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
//main.temp_max Maximum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
//main.sea_level Atmospheric pressure on the sea level, hPa
//main.grnd_level Atmospheric pressure on the ground level, hPa
//wind
//wind.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
//wind.deg Wind direction, degrees (meteorological)
//clouds
//clouds.all Cloudiness, %
//rain
//rain.3h Rain volume for the last 3 hours
//snow
//snow.3h Snow volume for the last 3 hours
//dt Time of data calculation, unix, UTC
//sys
//sys.type Internal parameter
//sys.id Internal parameter
//sys.message Internal parameter
//sys.country Country code (GB, JP etc.)
//sys.sunrise Sunrise time, unix, UTC
//sys.sunset Sunset time, unix, UTC
//id City ID
//name City name
//cod Internal parameter

import Foundation

class WeatherClient{
    
    // MARK: - properties
    private var urlString : String?
    private var appID : String?
    private var units : String?
    
    // MARK: - constructor
    init(urlString : String, appID : String, units : String){
        self.urlString = urlString
        self.appID = appID
        self.units = units
    }
    
    // MARK: - Current weather data
    func requestWeather(cityId : Int, onComplete complete: @escaping (Weather?)->()){
        let connectionString = String(format: "\(urlString!)id=\(cityId)&units=\(units!)&APPID=\(appID!)")
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var weather : Weather?
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let weatherData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        weather = Weather(cityId: cityId)
                        let dictionary = weatherData as! NSDictionary
                        
                        // 1. set city name
                        if let name = dictionary.value(forKey: "name"){
                            weather!.name = "\(name)"
                        }
                        
                        // 2. set city current temperature
                        if let main = dictionary.value(forKey: "main"){
                            if let temp = (main as! NSDictionary).value(forKey: "temp"){
                                weather!.temp = Double("\(temp)")
                            }
                        }
                    }
                }
            }else{
                print(error!)
            }
            complete(weather)
        }.resume()
    }
}
