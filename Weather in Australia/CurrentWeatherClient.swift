
//
//  WeatherClient.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation
import CoreLocation

class CurrentWeatherClient : NSObject{
    
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
    
    // MARK: - request current weather data
    
    // MARK: request weather data by city ID
    func requestWeather(cityId : Int, onComplete complete: @escaping (City?)->()){
        let connectionString = String(format: "\(urlString)id=\(cityId)&units=\(units.rawValue)&APPID=\(appID)")
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var city : City?
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary{
                        city = City(cityId: cityId)
                        
                        if let name = dictionary.value(forKey: "\(WeatherKeypath.name.rawValue)"){
                            city!.name = "\(name)"
                        }
                        let weather = Weather(dictionary: dictionary, withUnits: self.units)
                        city!.currentWeather = weather

                        if let countryCode = dictionary.value(forKeyPath: "\(WeatherKeypath.syscountry.rawValue)"){
                            city!.country = Country(countryCode: "\(countryCode)", nationalFlag: self.emojiFlag(countryCode: "\(countryCode)"))
                        }
                        
                        if let lat = Double("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlat.rawValue)")!)"),let lon = Double("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlon.rawValue)")!)"){
                            city!.location = GeoLocation(lat: lat, lon: lon)
                        }
                    }
                }
            }else{
                print(error!)
            }
            complete(city)
        }.resume()
    }
    
    // MARK: request weather data by a group of city ID
    func requestWeatherForCitys(cityIds: [Int], onComplete complete: @escaping ([City]?)->()){
        
        // build url string for group request
        let connectionString = NSMutableString()
        connectionString.append(urlString)
        connectionString.append("id=")
        
        for i in 0..<cityIds.count{
            connectionString.append("\(cityIds[i])")
            
            if i < cityIds.count - 1{
                connectionString.append(",")
            }
        }
        connectionString.append("&units=\(units)")
        connectionString.append("&appid=\(appID)")
        
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
                                let city = City(cityId: Int("\(dictionary.value(forKey: "\(WeatherKeypath.id.rawValue)")!)")!)

                                if let name = dictionary.value(forKey: "\(WeatherKeypath.name.rawValue)"){
                                    city.name = "\(name)"
                                }
                                let weather = Weather(dictionary: dictionary, withUnits: self.units)
                                city.currentWeather = weather
                                
                                if let countryCode = dictionary.value(forKeyPath: "\(WeatherKeypath.syscountry.rawValue)"){
                                    city.country = Country(countryCode: "\(countryCode)", nationalFlag: self.emojiFlag(countryCode: "\(countryCode)"))
                                }
                                
                                if let lat = Double(("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlat.rawValue)"))")),
                                    let lon = Double("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlon.rawValue)"))"){
                                    city.location = GeoLocation(lat: lat, lon: lon)
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
    
    // MARK: request weather data by geo location
    func requestWeatherForCurrentLocation(location: CLLocationCoordinate2D, onComplete complete:  @escaping (City?)->()){
        
        let connectionString = String(format: "\(urlString)lat=%.2f&lon=%.2f&units=\(units.rawValue)&APPID=\(appID)", arguments:[location.latitude, location.longitude])
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var city : City?
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary{

                        city = City(cityId: Int("\(dictionary.value(forKey: "\(WeatherKeypath.id.rawValue)")!)")!)

                        if let name = dictionary.value(forKey: "\(WeatherKeypath.name.rawValue)"){
                            city!.name = "\(name)"
                        }

                        let weather = Weather(dictionary: dictionary, withUnits: self.units)
                        city!.currentWeather = weather
                        
                        if let countryCode = dictionary.value(forKeyPath: "\(WeatherKeypath.syscountry.rawValue)"){
                            city!.country = Country(countryCode: "\(countryCode)", nationalFlag: self.emojiFlag(countryCode: "\(countryCode)"))
                        }
                        
                        if let lat = Double(("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlat.rawValue)"))")),
                            let lon = Double("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlon.rawValue)"))"){
                            city!.location = GeoLocation(lat: lat, lon: lon)
                        }
                    }
                }
            }else{
                print(error!)
            }
            complete(city)
        }.resume()
    }
    
    // MARK: request weather data by city name
    func requestWeatherForCity(name: String, onComplete complete: @escaping (City?)->()){
        let connectionString = String(format: "\(urlString)q=\(name)&units=\(units.rawValue)&APPID=\(appID)")//.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            var city : City?
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let weatherData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        let dictionary = weatherData as! NSDictionary
                        
                        city = City(cityId: Int("\(dictionary.value(forKey: "\(WeatherKeypath.id.rawValue)")!)")!)
                        
                        // 1. set city name
                        if let name = dictionary.value(forKey: "\(WeatherKeypath.name.rawValue)"){
                            city!.name = "\(name)"
                        }
                        
                        let weather = Weather(dictionary: dictionary, withUnits: self.units)
                        city!.currentWeather = weather
                        
                        if let countryCode = dictionary.value(forKeyPath: "\(WeatherKeypath.syscountry.rawValue)"){
                            city!.country = Country(countryCode: "\(countryCode)", nationalFlag: self.emojiFlag(countryCode: "\(countryCode)"))
                        }
                        
                        if let lat = Double(("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlat.rawValue)"))")),
                            let lon = Double("\(dictionary.value(forKeyPath: "\(WeatherKeypath.coordlon.rawValue)"))"){
                            city!.location = GeoLocation(lat: lat, lon: lon)
                        }
                    }
                }
            }else{
                print(error!)
            }
            complete(city)
        }.resume()
    }
    
    // MARK: national flag representation by country code
    private func emojiFlag(countryCode: String) -> String {
        var string = ""
        var country = countryCode.uppercased()
        for uS in country.unicodeScalars {
            string.append(_: "\(UnicodeScalar(127397 + uS.value)!)")
        }
        return string
    }
}
