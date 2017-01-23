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
    
    // test OpenWeatherMap web service
    func testWeatherWebService() {
        let expectation = self.expectation(description: "Expectations")
        
        let apiKey = "3fe25736cbd429e82dd9abb3afca0002"
        let cityId = 4163971

        let connection = "http://api.openweathermap.org/data/2.5/weather?id=\(cityId)&units=metric&APPID=\(apiKey)"
        let url = URL(string: connection)
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: 10.0)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error == nil && data != nil{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200{
                    if let weatherData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments){
                        print(weatherData)
                        
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
    
}
