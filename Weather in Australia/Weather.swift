//
//  Weather.swift
//  Weather in Australia
//
//  Created by David Ye on 26/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation
import UIKit

class Weather{
    
    // MARK: - properties for weather attributes
    var temperature : Double?
    var humidity : Int?
    var pressure : Double?
    var windSpeed : Double?
    var weatherDescription : String?
    var weatherIcon : String?
    
    var weatherMain : String?
    var maxTemperature : Double?
    var minTemperature :Double?
    
    var sunrise : Date?
    var sunset : Date?
    
    var units : Units?
    
    // MARK: - constructor
    init(dictionary: NSDictionary, withUnits units: Units) {
        if let temperature = dictionary.value(forKeyPath: "\(WeatherKeypath.maintemp.rawValue)"),
            let humidity = dictionary.value(forKeyPath: "\(WeatherKeypath.mainhumidity.rawValue)"),
            let pressure = dictionary.value(forKeyPath: "\(WeatherKeypath.mainpressure.rawValue)"),
            let windspeed = dictionary.value(forKeyPath: "\(WeatherKeypath.windspeed.rawValue)"),
            let weatherDescription = dictionary.value(forKeyPath: "\(WeatherKeypath.weatherdescription.rawValue)"),
            let weatherIcon = dictionary.value(forKeyPath: "\(WeatherKeypath.weathericon.rawValue)"),
            let weatherMain = dictionary.value(forKeyPath: "\(WeatherKeypath.weathermain.rawValue)"),
            let maxTemp = dictionary.value(forKeyPath: "\(WeatherKeypath.maintemp_max.rawValue)"),
            let minTemp = dictionary.value(forKeyPath: "\(WeatherKeypath.maintemp_min.rawValue)"),
            let sunrise = dictionary.value(forKeyPath: "\(WeatherKeypath.syssunrise.rawValue)"),
            let sunset = dictionary.value(forKeyPath: "\(WeatherKeypath.syssunset.rawValue)"){
            
            self.temperature = Double(String(format: "\(temperature)"))
            self.humidity = Int(String(format: "\(humidity)"))
            self.pressure = Double(String(format: "\(pressure)"))
            self.windSpeed = Double(String(format: "\(windspeed)"))
            self.weatherDescription = "\((weatherDescription as! NSArray)[0])"
            self.weatherIcon = "\((weatherIcon as! NSArray)[0])"
            self.weatherMain = "\((weatherMain as! NSArray)[0])"
            self.maxTemperature = Double(String(format: "\(maxTemp)"))
            self.minTemperature = Double(String(format: "\(minTemp)"))
            self.sunrise = Date.init(timeIntervalSince1970: TimeInterval("\(sunrise)")!)
            self.sunset = Date.init(timeIntervalSince1970: TimeInterval("\(sunset)")!)
            self.units = units
        }
    }
    
    // MARK: - method for fetch weather icon image from file path
    func getWeatherIconImage()->UIImage?{
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let imagePath = documentsDirectory.appending("\(weatherIcon!).png")
        if FileManager.default.fileExists(atPath: imagePath) == true{
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }
    
    // MARK: method for save weather icon image to file path
    func saveWeatherIconImage(data: Data?){
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let imagePath = documentsDirectory.appending("\(weatherIcon!).png")
        if FileManager.default.fileExists(atPath: imagePath) == false{
            try? data!.write(to: URL(fileURLWithPath: imagePath), options: [.atomic])
        }
    }
}
