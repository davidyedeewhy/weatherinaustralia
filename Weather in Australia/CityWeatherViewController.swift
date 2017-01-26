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
    private let width = UIScreen.main.bounds.size.width
    
    // MARK: - view life circle
    override func viewDidLoad() {
        super.viewDidLoad()

        if city != nil{
            configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - functions
    private func configureView(){
        // MARK: 1. set header view
        let headerBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 180))
        headerBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.addSubview(headerBackgroundView)
        
        var y : CGFloat = 70
        // MARK: 2. city name
        addCityName(position: &y)
        // MARK: 3. Weather main summary
        addWeathermain(position: &y)
        // MARK: 4. Weather icon to represent current condition
        addWeatherIcon(position: y)
        // MARK: 5. Temperature
        addMainTemp(position: &y)
        // MARK: 6. Add line between header and content
        addLine(position: &y)
        // MARK: 7. Current weather desciption
        addWeatherDescription(position: &y)
        // MARK: 8. Sunrise and sunset with city's timezone
        addCitySunriseAndSunset(position: &y)
        // MARK: 9. Humidity
        addHumidity(position: &y)
        // MARK: 10. Wind speed with unit(metric or imperial)
        addWindSpeed(position: &y)
        // MARK: 11. Pressure
        addWeatherPressure(position: &y)
        // MARK: 12. Current max and min temperature around city area
        // I tried to get daily max and min temperature, but the response data is so funny. 
        // I already check the city ID and time. Everything seems normal, but just data doesn't make sense
        // So finally I choose current max and min temperature.
        addMaxTemp(position: &y)
        addMinTemp(position: &y)
        
        for subview in view.subviews{
            if subview is UILabel{
                (subview as! UILabel).textColor = UIColor.white
            }
        }
    }
    
    private func addCityName(position y: inout CGFloat){
        let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 30))
        let attributedText = NSMutableAttributedString(string: "\(city!.name!) \(city!.country!.countryCode)")
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 25)], range: NSMakeRange(0, "\(city!.name!)".characters.count))
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 8)], range: NSMakeRange("\(city!.name!)".characters.count,city!.country!.countryCode.characters.count + 1))

        labelText.textAlignment = .center
        labelText.attributedText = attributedText
        view.addSubview(labelText)
        
        y = y + 30
    }
    
    private func addWeathermain(position y: inout CGFloat){
        let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 22))
        labelText.font = UIFont.systemFont(ofSize: 19)
        labelText.textAlignment = .center
        labelText.text = "\(city!.currentWeather!.weatherMain!)"
        view.addSubview(labelText)
        y = y + 22
    }

    private func addMainTemp(position y: inout CGFloat){
        let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 50))
        labelText.font = UIFont.systemFont(ofSize: 48, weight: 0.1)
        labelText.textAlignment = .center
        
        let symbol = city!.currentWeather!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
        var temperature : Int = 0
        let mainTemperature = Int(round(self.city!.currentWeather!.temperature!))
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            if mainTemperature > temperature{
                temperature = temperature + 1
            }else if mainTemperature < temperature{
                temperature = temperature - 1
            }

            let attributedText = NSMutableAttributedString(string: "\(temperature)\(symbol)")
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 48)], range: NSMakeRange(0, "\(temperature)".characters.count))
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSBaselineOffsetAttributeName:22], range: NSMakeRange("\(temperature)".characters.count,symbol.characters.count))
            labelText.attributedText = attributedText
            
            if temperature == mainTemperature{
                timer.invalidate()
            }
            
        })
        
        view.addSubview(labelText)
        y = y + 50
    }
    
    private func addWeatherIcon(position y: CGFloat){
        if let icon = city!.currentWeather!.getWeatherIconImage(){
            let imageView = UIImageView(frame: CGRect(x: width * 0.1, y: width * 0.23 , width: icon.size.width * 1.5, height: icon.size.height * 1.5))
            imageView.image = icon
            self.view.addSubview(imageView)
        }else{
            let weatherConditionClient = WeatherConditionClient()
            weatherConditionClient.requestWeatherIcon(iconID: "\(city!.currentWeather!.weatherIcon!)", onComplete: { (data) in
                if data != nil{
                    self.city!.currentWeather!.saveWeatherIconImage(data: data)
                    OperationQueue.main.addOperation({
                        if let image = UIImage(data: data!){
                            let width = UIScreen.main.bounds.size.width
                            let imageView = UIImageView(frame: CGRect(x: width * 0.1, y: width * 0.23, width: image.size.width, height: image.size.height))
                            imageView.image = image
                            self.view.addSubview(imageView)
                        }
                    })
                }
            })
        }
    }
    
    private func addLine(position y: inout CGFloat){
        let line1 = UIView(frame: CGRect(x: 0, y: y, width: width, height: 1))
        line1.backgroundColor = UIColor.lightGray
        //view.addSubview(line1)
        y = y + 20
    }
    
    private func addWeatherDescription(position y: inout CGFloat){
        let labelText = UILabel()
        labelText.numberOfLines = 0
        labelText.text = "Today - \(city!.currentWeather!.weatherDescription!)"
        let size = labelText.sizeThatFits(CGSize(width: width * 0.8, height: CGFloat.greatestFiniteMagnitude))
        labelText.frame = CGRect(x: width * 0.1, y: y, width: width * 0.8, height: size.height)
        labelText.textAlignment = .center
        
        view.addSubview(labelText)
        y = y + size.height
    }
    
    private func addCitySunriseAndSunset(position y: inout CGFloat){
        let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
        labeltTitle.text = "Sunrise: "
        labeltTitle.textAlignment = .right
        view.addSubview(labeltTitle)
        
        let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))

        if city!.timezone != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = city!.timezone!
            dateFormatter.dateFormat = "HH:mm"
            labelText.text = "  \(dateFormatter.string(from: city!.currentWeather!.sunrise!))"
            view.addSubview(labelText)
        }
        y = y + 20
        
        let labeltTitle1 = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
        labeltTitle1.text = "Sunset: "
        labeltTitle1.textAlignment = .right
        view.addSubview(labeltTitle1)
        
        let labelText1 = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
        if city!.timezone != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = city!.timezone!
            dateFormatter.dateFormat = "HH:mm"
            labelText1.text = "  \(dateFormatter.string(from: city!.currentWeather!.sunset!))"
            view.addSubview(labelText1)
        }
        y = y + 20
        
        if city!.currentWeather!.sunrise != nil && city!.currentWeather!.sunset != nil{
            // MARK: change background to show day or night based on current time.
            if Date() > city!.currentWeather!.sunrise! && Date() < city!.currentWeather!.sunset!{
                view.backgroundColor = UIColor(patternImage: UIImage(named: "day.png")!)
            }else{
                view.backgroundColor = UIColor(patternImage: UIImage(named: "night.jpg")!)
            }
        }
    }
    
    private func addHumidity(position y: inout CGFloat){
        let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
        labeltTitle.text = "Humidity: "
        labeltTitle.textAlignment = .right
        view.addSubview(labeltTitle)
        
        let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
        labelText.text = "  \(city!.currentWeather!.humidity!)%"
        
        view.addSubview(labelText)
        y = y + 20
    }
    
    private func addWindSpeed(position y: inout CGFloat){
        let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
        labeltTitle.text = "Wind speed: "
        labeltTitle.textAlignment = .right
        view.addSubview(labeltTitle)
        
        // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
        let symbol = city!.currentWeather!.units! == Units.metric ? "\(UnitSpeed.metersPerSecond.symbol)" : "\(UnitSpeed.milesPerHour.symbol)"
        
        let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
        labelText.text = "  \(city!.currentWeather!.windSpeed!) \(symbol)"
        view.addSubview(labelText)
        y = y + 20
    }
    
    private func addWeatherPressure(position y: inout CGFloat){
        let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
        labeltTitle.text = "Pressure: "
        labeltTitle.textAlignment = .right
        view.addSubview(labeltTitle)
        
        let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
        labelText.text = "  \(city!.currentWeather!.pressure!) \(UnitPressure.hectopascals.symbol)"
        view.addSubview(labelText)
        y = y + 20
    }
    
    private func addMaxTemp(position y: inout CGFloat){
        let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
        labeltTitle.text = "Max Temp: "
        labeltTitle.textAlignment = .right
        view.addSubview(labeltTitle)
        
        let symbol = city!.currentWeather!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
        
        let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
        labelText.text = "  \(city!.currentWeather!.maxTemperature!) \(symbol)"
        view.addSubview(labelText)
        
        y = y + 20
    }
    
    private func addMinTemp(position y: inout CGFloat){
        let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
        labeltTitle.text = "Min Temp: "
        labeltTitle.textAlignment = .right
        view.addSubview(labeltTitle)
        
        let symbol = city!.currentWeather!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
        
        let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
        labelText.text = "  \(city!.currentWeather!.minTemperature!) \(symbol)"
        view.addSubview(labelText)
        y = y + 20
    }
}
