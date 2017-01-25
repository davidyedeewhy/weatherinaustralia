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
            //navigationItem.title = "\(city!.name!)"
            configureView()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - functions
    // TODO: 1. city.name City name
    private func addCityName(dictionary: NSDictionary, position y: inout CGFloat){
        //city.name City name
        if let str = dictionary.value(forKeyPath: "\(Weather.name.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 30))
            labelText.font = UIFont.systemFont(ofSize: 25)
            labelText.textAlignment = .center
            labelText.text = "\(str)"
            view.addSubview(labelText)
            y = y + 30
        }
    }
    
    // TODO: 2. Group of weather parameters (Rain, Snow, Extreme etc.)
    private func addWeathermain(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "\(Weather.weathermain.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 22))
            labelText.font = UIFont.systemFont(ofSize: 19)
            labelText.textAlignment = .center
            labelText.text = "\((str as! NSArray)[0])"
            view.addSubview(labelText)
            y = y + 22
        }
    }
    
    // TODO: 3. weather main temp
    private func addMainTemp(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "\(Weather.maintemp.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 50))
            labelText.font = UIFont.systemFont(ofSize: 48, weight: 0.1)
            labelText.textAlignment = .center
            
            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            var temperature = 0.0
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                if let mainTemperature = Double("\(str)"){
                    if mainTemperature > temperature{
                        temperature = temperature + 1
                    }else if mainTemperature < temperature{
                        temperature = temperature - 1
                    }
                    
                    let temp = String(format: "%.0f", arguments: [temperature])
                    let attributedText = NSMutableAttributedString(string: "\(temp)\(symbol)")
                    attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 48)], range: NSMakeRange(0, "\(temp)".characters.count))
                    attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSBaselineOffsetAttributeName:22], range: NSMakeRange("\(temp)".characters.count,symbol.characters.count))
                    labelText.attributedText = attributedText
                    
                    if Int(temperature) == Int(mainTemperature){
                        timer.invalidate()
                    }
                }
            })
            
            view.addSubview(labelText)
            y = y + 50
        }
    }
    
    // TODO: 4. weather icon
    private func addWeatherIcon(dictionary: NSDictionary, withPosition y: CGFloat){
        if let str = dictionary.value(forKeyPath: "\(Weather.weathericon.rawValue)"){
            let weatherConditionClient = WeatherConditionClient()
            weatherConditionClient.requestWeatherIcon(iconID: "\((str as! NSArray)[0])", onComplete: { (data) in
                if data != nil{
                    OperationQueue.main.addOperation({
                        if let image = UIImage(data: data!){
                            let width = UIScreen.main.bounds.size.width
                            let imageView = UIImageView(frame: CGRect(x: width * 0.2, y: y, width: image.size.width / 2.0, height: image.size.height / 2.0))
                            imageView.image = image
                            self.view.addSubview(imageView)
                        }
                    })
                }
            })
        }
    }
    
    private func addLine(position y: inout CGFloat){
        let width = UIScreen.main.bounds.size.width
        let line1 = UIView(frame: CGRect(x: 0, y: y, width: width, height: 1))
        line1.backgroundColor = UIColor.lightGray
        view.addSubview(line1)
        y = y + 6
    }
    
    private func configureView(){
        guard let dictionary = city!.dictionary else {
            return
        }
        
        var y : CGFloat = 70
        let width = UIScreen.main.bounds.size.width
        
        //city.name City name
        addCityName(dictionary: dictionary, position: &y)

        addWeathermain(dictionary: dictionary, withPosition: &y)
        
        addMainTemp(dictionary: dictionary, withPosition: &y)

        addLine(position: &y)
        
        addWeatherIcon(dictionary: dictionary, withPosition: y)
        
        if let str = dictionary.value(forKeyPath: "\(Weather.cod.rawValue)"){
            print(str)
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.weatherdescription.rawValue)"){
            let labelText = UILabel()
            labelText.numberOfLines = 0
            labelText.text = "Today - \((str as! NSArray)[0])"
            let size = labelText.sizeThatFits(CGSize(width: width * 0.8, height: CGFloat.greatestFiniteMagnitude))
            labelText.frame = CGRect(x: width * 0.1, y: y, width: width * 0.8, height: size.height)
            labelText.textAlignment = .center
            
            view.addSubview(labelText)
            y = y + size.height
        }
        
        let line2 = UIView(frame: CGRect(x: 0, y: y + 3, width: width, height: 1))
        line2.backgroundColor = UIColor.lightGray
        view.addSubview(line2)
        
        y = y + 6
        
        if let str = dictionary.value(forKeyPath: "\(Weather.syssunrise.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Sunrise: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            let date = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
            
            if city!.timezone != nil{
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = city!.timezone!
                dateFormatter.dateFormat = "HH:mm"
                labelText.text = "  \(dateFormatter.string(from: date))"
                view.addSubview(labelText)
            }
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.syssunset.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Sunset: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            let date = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
            if city!.timezone != nil{
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = city!.timezone!
                dateFormatter.dateFormat = "HH:mm"
                labelText.text = "  \(dateFormatter.string(from: date))"
                view.addSubview(labelText)
            }
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.mainhumidity.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.mainhumidity): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  0%"
            
            var humidity : Int = 0
            Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                if humidity < Int("\(str)")!{
                    humidity = humidity + 1
                    labelText.text = " \(humidity)%"
                }else{
                    timer.invalidate()
                }
            })
            
            view.addSubview(labelText)
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.windspeed.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.windspeed): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
            let symbol = city!.units! == Units.metric ? "\(UnitSpeed.metersPerSecond.symbol)" : "\(UnitSpeed.milesPerHour.symbol)"
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.mainpressure.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.mainpressure): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)

            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(UnitPressure.hectopascals.symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.maintemp_max.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.maintemp_max): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.maintemp_min.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.maintemp_min): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
    }
}
