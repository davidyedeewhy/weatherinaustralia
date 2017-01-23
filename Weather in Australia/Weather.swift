//
//  City.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

class Weather : NSObject {
    
    let cityId : Int
    var name : String?
    var temp : Int?
    
    init(cityId: Int){
        self.cityId = cityId
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return self.cityId == (object as! Weather).cityId
    }
}
