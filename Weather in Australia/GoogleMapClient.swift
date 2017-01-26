//
//  GoogleMapClient.swift
//  Weather in Australia
//
//  Created by David Ye on 25/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import Foundation

class GoogleMapClient{
    private let timezoneRequestString = "https://maps.googleapis.com/maps/api/timezone/json?"
    private let addressRequestString = "https://maps.googleapis.com/maps/api/geocode/json?"
    
    func requestTimezone(location: GeoLocation, timestamp: Date, onComplete complete:@escaping (TimeZone?)->()){
        let _timestamp = Int(timestamp.timeIntervalSince1970.rounded())
        let connectionString = String(format: "\(timezoneRequestString)location=\(location.lat),\(location.lon)&timestamp=\(_timestamp)&key=\(ServiceKey.GoogleMap.rawValue)")
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        if let timezone = TimeZone(identifier: "\((dictionary as! NSDictionary).value(forKey: "timeZoneId")!)"){
                            complete(timezone)
                        }
                    }
                }
            }else{
                print(error!)
            }
            complete(nil)
        }.resume()
    }
    
    func requestAddress(location: GeoLocation, complete: @escaping (String?)->()){
        let connectionString = String(format: "\(addressRequestString)latlng=\(location.lat),\(location.lon)&key=\(ServiceKey.GoogleMap.rawValue)")
        let url = URL(string: connectionString)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        print(dictionary)
                    }
                }
            }else{
                print(error!)
            }
            complete(nil)
        }.resume()
    }
}






