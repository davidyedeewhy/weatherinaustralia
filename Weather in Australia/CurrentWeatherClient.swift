
//
//  WeatherClient.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

class CurrentWeatherClient{
    
    // MARK: - properties
    private var urlString : String?
    private var appID : String?
    private var units : Units?
    
    // MARK: - constructor
    init(urlString : String, appID : String, units : Units){
        self.urlString = urlString
        self.appID = appID
        self.units = units
    }
    
    // MARK: - Current weather data
    func requestWeather(cityId : Int, onComplete complete: @escaping (City?)->()){
        let connectionString = String(format: "\(urlString!)id=\(cityId)&units=\(units!.rawValue)&APPID=\(appID!)")
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var city : City?
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let weatherData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        //city = City(cityId: cityId)
                        let dictionary = weatherData as! NSDictionary
                        
                        city = City(cityId: Int("\(dictionary.value(forKey: "id")!)")!)
                        
                        // 1. set city name
                        if let name = dictionary.value(forKey: "name"){
                            city!.name = "\(name)"
                        }
                        
                        if let clouds = dictionary.value(forKey: "clouds") as? NSDictionary{
                            city!.cloud = Cloud(all: Double("\(clouds.value(forKey: "all")!)")!)
                        }
                        
                        if let location = dictionary.value(forKey: "coord") as? NSDictionary{
                            city?.location = GeoLocation(lat: Double("\(location.value(forKey: "lat")!)")!, lon: Double("\(location.value(forKey: "lon")!)")!)
                        }
                        
                        if let main = dictionary.value(forKey: "main") as? NSDictionary{
                            let symbol = self.units! == Units.metric ? UnitTemperature.celsius.symbol : self.units! == Units.imperial ? UnitTemperature.fahrenheit.symbol : ""
                            city?.weather = Weather(humidity: Double("\(main.value(forKey: "humidity")!)")!,
                                                   pressure: Double("\(main.value(forKey: "pressure")!)")!,
                                                   temp: Double("\(main.value(forKey: "temp")!)")!,
                                                   tempMax: Double("\(main.value(forKey: "temp_max")!)")!,
                                                   tempMin: Double("\(main.value(forKey: "temp_min")!)")!,
                                                   tempSymbol: symbol)
                        }
                        
                        if let sys = dictionary.value(forKey: "sys") as? NSDictionary{
                            city?.weatherSys = WeatherSys(sunrise: Date.init(timeIntervalSince1970: TimeInterval("\(sys.value(forKey: "sunrise")!)")!),
                                                         sunset: Date.init(timeIntervalSince1970: TimeInterval("\(sys.value(forKey: "sunset")!)")!))
                        }
                        
                        if let wind = dictionary.value(forKey: "wind") as? NSDictionary{
                            city?.wind = Wind(deg: Double("\(wind.value(forKey: "deg")!)")!,
                                             speed: Double("\(wind.value(forKey: "speed")!)")!)
                        }
                        
                        if let weatherMains = dictionary.value(forKey: "weather") as? [NSDictionary]{
                            if weatherMains.count > 0{
                                let weatherMain = weatherMains[0]
                                
                                city?.weatherMain = WeatherMain(icon: "\(weatherMain.value(forKey: "icon")!)",
                                    mainDescription: "\(weatherMain.value(forKey: "description")!)",
                                    main: "\(weatherMain.value(forKey: "main")!)")
                            }
                        }
                    }
                }
            }else{
                print(error!)
            }
            complete(city)
        }.resume()
    }
    
    func requestWeatherForCitys(cityIds: [Int], onComplete complete: @escaping ([City]?)->()){
        
        let connectionString = NSMutableString()
        connectionString.append(urlString!)
        connectionString.append("id=")
        
        for i in 0..<cityIds.count{
            connectionString.append("\(cityIds[i])")
            
            if i < cityIds.count - 1{
                connectionString.append(",")
            }
        }
        connectionString.append("&units=\(units!)")
        connectionString.append("&appid=\(appID!)")
        
        let url = URL(string: connectionString as String)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 30.0)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let weatherData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        if let list = (weatherData as! NSDictionary).value(forKey: "list"){
                            
                            var cities = [City]()
                            
                            for dictionary in (list as! [NSDictionary]){
                                let city = City(cityId: Int("\(dictionary.value(forKey: "id")!)")!)

                                // 1. set city name
                                if let name = dictionary.value(forKey: "name"){
                                    city.name = "\(name)"
                                }
                                
                                if let clouds = dictionary.value(forKey: "clouds") as? NSDictionary{
                                    city.cloud = Cloud(all: Double("\(clouds.value(forKey: "all")!)")!)
                                }
                                
                                if let location = dictionary.value(forKey: "coord") as? NSDictionary{
                                    city.location = GeoLocation(lat: Double("\(location.value(forKey: "lat")!)")!, lon: Double("\(location.value(forKey: "lon")!)")!)
                                }
                                
                                if let main = dictionary.value(forKey: "main") as? NSDictionary{
                                    let symbol = self.units! == Units.metric ? UnitTemperature.celsius.symbol : self.units! == Units.imperial ? UnitTemperature.fahrenheit.symbol : ""
                                    city.weather = Weather(humidity: Double("\(main.value(forKey: "humidity")!)")!,
                                                           pressure: Double("\(main.value(forKey: "pressure")!)")!,
                                                               temp: Double("\(main.value(forKey: "temp")!)")!,
                                                            tempMax: Double("\(main.value(forKey: "temp_max")!)")!,
                                                            tempMin: Double("\(main.value(forKey: "temp_min")!)")!,
                                                         tempSymbol: symbol)
                                }
                                
                                if let sys = dictionary.value(forKey: "sys") as? NSDictionary{
                                    city.weatherSys = WeatherSys(sunrise: Date.init(timeIntervalSince1970: TimeInterval("\(sys.value(forKey: "sunrise")!)")!),
                                                                  sunset: Date.init(timeIntervalSince1970: TimeInterval("\(sys.value(forKey: "sunset")!)")!))
                                }
                                
                                if let wind = dictionary.value(forKey: "wind") as? NSDictionary{
                                    city.wind = Wind(deg: Double("\(wind.value(forKey: "deg")!)")!,
                                                      speed: Double("\(wind.value(forKey: "speed")!)")!)
                                }
                                
                                if let weatherMains = dictionary.value(forKey: "weather") as? [NSDictionary]{
                                    if weatherMains.count > 0{
                                        let weatherMain = weatherMains[0]
                                        
                                        city.weatherMain = WeatherMain(icon: "\(weatherMain.value(forKey: "icon")!)",
                                            mainDescription: "\(weatherMain.value(forKey: "description")!)",
                                            main: "\(weatherMain.value(forKey: "main")!)")
                                    }
                                }
                                
                                cities.append(city)
                            }
                            
                            complete(cities)
                        }
                    }
                }
            }else{
                print(error!)
            }
        }.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
