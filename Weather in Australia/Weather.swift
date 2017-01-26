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
    
    var temperature : Double?
    var humidity : Int?
    var pressure : Int?
    var windSpeed : Double?
    var weatherDescription : String?
    var weatherIcon : String?
    
    
    func getWeatherIconImage()->UIImage?{
        return UIImage()
    }
    
    func saveWeatherIconImage(){
    
    }
}
