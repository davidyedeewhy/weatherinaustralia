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
    var country : Country?
    var name : String?
    var location : GeoLocation?
    var timezone : TimeZone?
    var currentWeather : Weather?
    
    // MARK: - constructor
    init(cityId: Int){
        self.cityId = cityId
    }

    // MARK: - override NSObject method
    override func isEqual(_ object: Any?) -> Bool {
        return self.cityId == (object as! City).cityId
    }
}

// MARK: - struct: country
struct Country{
    let countryCode : String
    let nationalFlag : String
}

// MARK: - struct: GeoLocation
struct GeoLocation {
    let lat : Double
    let lon : Double
}

