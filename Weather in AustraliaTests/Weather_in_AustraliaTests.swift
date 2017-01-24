//
//  Weather_in_AustraliaTests.swift
//  Weather in AustraliaTests
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import XCTest
@testable import Weather_in_Australia

class Weather_in_AustraliaTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGeoLocation(){
        //let location = GeoLocation(lat: 28.08, lon: -80.61)
        
        //print(location.lat!)
    }
    
    // test OpenWeatherMap web service
    func testWeatherWebService() {
        let expectation = self.expectation(description: "Expectations")
        
        let apiKey = "3fe25736cbd429e82dd9abb3afca0002"
        let cityId = 2174003 //[4163971, 2147714, 2174003]

        let connection = "http://api.openweathermap.org/data/2.5/weather?id=\(cityId)&units=\(Units.imperial.rawValue)&APPID=\(apiKey)"
        let url = URL(string: connection)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let weatherData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        print((weatherData as! NSDictionary))
                        
                        expectation.fulfill()
                    }
                }
            }else{
                print(error!)
            }
        }.resume()
        
        waitForExpectations(timeout: 10) { (error) in
            if error != nil{
                print(error!)
            }
        }
    }

//    func testWeatherClient(){
//        let expectation = self.expectation(description: "Expectations")
//        
//        let apiKey = "3fe25736cbd429e82dd9abb3afca0002"
//        //let cityId = 4163971
//        
//        //http://api.openweathermap.org/data/2.5/group?id=524901,703448,2643743&units=metric&appid=b1b15e88fa797225412429c1c50c122a1
//        let weatherClient = CurrentWeatherClient(urlString: "http://api.openweathermap.org/data/2.5/group?", appID: apiKey, units: Units.metric)
//        //weatherClient//.requestWeather(currentWeather: "http://api.openweathermap.org/data/2.5/weather?", withApiKey: apiKey, units: "metric", forCity: cityId)
//        
//        weatherClient.requestWeatherForCitys(cityIds: [4163971, 2147714, 2174003]) { (cities) in
//            print(cities!)
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 60) { (error) in
//            if error != nil{
//                print(error!)
//            }
//        }
//    }
    
}
