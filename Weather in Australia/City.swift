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
    var dictionary : NSDictionary?
    var units : Units?
    
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

enum Weather : String{
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
