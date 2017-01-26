//
//  Constant.swift
//  Weather in Australia
//
//  Created by David Ye on 25/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

enum ServiceKey : String{
    case OpenWeatherMap = "3fe25736cbd429e82dd9abb3afca0002"
    case GoogleMap = "AIzaSyBI3lmA_X3F5Z9Gnwry7arG-eVD4tx-QoA"
}

enum Units : String{
    case metric = "metric"
    case imperial = "imperial"
}

enum WeatherKeypath : String{
    case base = "base"
    case id = "id"
    case dt = "dt"
    case mainhumidity = "main.humidity"
    case maintemp_max = "main.temp_max"
    case maintemp_min = "main.temp_min"
    case maintemp = "main.temp"
    case mainpressure = "main.pressure"
    case coordlon = "coord.lon"
    case coordlat = "coord.lat"
    case windspeed = "wind.speed"
    case winddeg = "wind.deg"
    case sysid = "sys.id"
    case sysmessage = "sys.message"
    case syscountry = "sys.country"
    case systype = "sys.type"
    case syssunset = "sys.sunset"
    case syssunrise = "sys.sunrise"
    case weatherid = "weather.id"
    case weathermain = "weather.main"
    case weathericon = "weather.icon"
    case weatherdescription = "weather.description"
    case visibility = "visibility"
    case cloudsall = "clouds.all"
    case cod = "cod"
    case name = "name"
}

enum WeatherNotification{
    case WeatherLoadingFinish
}

enum OpenWeatherMapService : String{
    //Access current weather data for any location on Earth including over 200,000 cities! Current weather is frequently updated based on global models and data from more than 40,000 weather stations. Data is available in JSON, XML, or HTML format.
    case currentWeather = "http://api.openweathermap.org/data/2.5/weather?"
    
    // Call for several city IDs
    case currentWeatherForCities = "http://api.openweathermap.org/data/2.5/group?"
    
    //5 day forecast is available at any location or city. It includes weather data every 3 hours. Forecast is available in JSON or XML format.
    case fiveDaysForecast = "http://api.openweathermap.org/data/2.5/forecast?"
    
    //16 day forecasts is available at any location or city. Forecasts include daily weather and available in JSON or XML format.
    case sixteenDailyForecast = "http://api.openweathermap.org/data/2.5/forecast/daily?"
}
