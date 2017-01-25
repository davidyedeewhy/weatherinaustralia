//
//  City.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

class City : NSObject{
    // MARK: - properties
    let cityId : Int
    var countryCode : String?
    var name : String?
    var location : GeoLocation?
    var timezone : TimeZone?
    var units : Units?
    
    // MARK: city's current weather data
    var dictionary : NSDictionary?
    
    // MARK: - constructor
    init(cityId: Int){
        self.cityId = cityId
    }
    
    // MARK: - override nsobject method
    override func isEqual(_ object: Any?) -> Bool {
        return self.cityId == (object as! City).cityId
    }
}

struct GeoLocation {
    let lat : Double
    let lon : Double
}
