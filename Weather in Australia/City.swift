//
//  City.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

class City : NSObject{
    //id City ID
    let cityId : Int
    //name City name
    var name : String?
    var location : GeoLocation?
    var weather : Weather?
    var wind : Wind?
    var cloud : Cloud?
    var weatherSys : WeatherSys?
    var weatherMain : WeatherMain?
    
    init(cityId: Int){
        self.cityId = cityId
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return self.cityId == (object as! City).cityId
    }
}

enum Units : String{
    case metric = "metric"
    case imperial = "imperial"
}


// MARK: - coord
//coord.lon City geo location, longitude
//coord.lat City geo location, latitude
struct GeoLocation {
    let lat : Double
    let lon : Double
}

// MARK: - main
//main.temp Temperature. Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
//main.pressure Atmospheric pressure (on the sea level, if there is no sea_level or grnd_level data), hPa
//main.humidity Humidity, %
//main.temp_min Minimum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
//main.temp_max Maximum temperature at the moment. This is deviation from current temp that is possible for large cities and megalopolises geographically expanded (use these parameter optionally). Unit Default: Kelvin, Metric: Celsius, Imperial: Fahrenheit.
//main.sea_level Atmospheric pressure on the sea level, hPa
//main.grnd_level Atmospheric pressure on the ground level, hPa
struct Weather {
    let humidity : Double
    let pressure : Double
    let temp : Double
    let tempMax : Double
    let tempMin : Double
    let tempSymbol : String
}

// MARK: - wind
//wind.speed Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
//wind.deg Wind direction, degrees (meteorological)
struct Wind {
    let deg : Double
    let speed : Double
}

// MARK: - clouds
//clouds.all Cloudiness, %
struct Cloud {
    let all : Double
}

// MARK: - sys
//sys.type Internal parameter
//sys.id Internal parameter
//sys.message Internal parameter
//sys.country Country code (GB, JP etc.)
//sys.sunrise Sunrise time, unix, UTC
//sys.sunset Sunset time, unix, UTC
struct WeatherSys {
    let sunrise : Date
    let sunset : Date
}

// MARK: - weather (more info Weather condition codes)
//weather.id Weather condition id
//weather.main Group of weather parameters (Rain, Snow, Extreme etc.)
//weather.description Weather condition within the group
//weather.icon Weather icon id
struct WeatherMain {
    let icon : String
    let mainDescription : String
    let main : String
}


// MARK:rain
//rain.3h Rain volume for the last 3 hours
//snow
//snow.3h Snow volume for the last 3 hours
//dt Time of data calculation, unix, UTC
