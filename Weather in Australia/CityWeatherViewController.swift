//
//  CityWeatherViewController.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import UIKit

class CityWeatherViewController: UIViewController {
    // MARK: - properties
    var city : City?
    
    // MARK: - view life circle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if city != nil{
            navigationItem.title = "\(city!.name!)"
            configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - functions
    private func configureView(){
        var y : CGFloat = 100
        let width = UIScreen.main.bounds.size.width
        
        if city != nil{
            if city!.weatherSys != nil{
                let labelSunriseTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
                labelSunriseTitle.text = "Sunrise: "
                labelSunriseTitle.textAlignment = .right
                view.addSubview(labelSunriseTitle)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                
                let labelSunrise = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
                labelSunrise.text = " \(dateFormatter.string(from: city!.weatherSys!.sunrise))"
                view.addSubview(labelSunrise)
                
                y = y + 20
                
                let labelSunsetTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
                labelSunsetTitle.text = "Sunset: "
                labelSunsetTitle.textAlignment = .right
                view.addSubview(labelSunsetTitle)
                
                let labelSunset = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
                labelSunset.text = " \(dateFormatter.string(from: city!.weatherSys!.sunset))"
                view.addSubview(labelSunset)
                
                y = y + 20
            }
            
            if city!.weather != nil{
                let labelHumidityTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
                labelHumidityTitle.text = "Humidity: "
                labelHumidityTitle.textAlignment = .right
                view.addSubview(labelHumidityTitle)
                
                let labelHumidity = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
                labelHumidity.text = String(format: " %.0f%@", arguments: [city!.weather!.humidity, "%"])
                view.addSubview(labelHumidity)
                
                y = y + 20
                
                let labelpressureTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
                labelpressureTitle.text = "Pressure: "
                labelpressureTitle.textAlignment = .right
                view.addSubview(labelpressureTitle)
                
                let labelpressure = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
                labelpressure.text = String(format: " %.0f", arguments: [city!.weather!.pressure])
                view.addSubview(labelpressure)
                
                y = y + 20
                
                
            }
        }
    }
}
