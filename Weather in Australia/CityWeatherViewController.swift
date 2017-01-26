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
    private func configureView(){
        guard let dictionary = city!.dictionary else {
            return
        }
        
        var y : CGFloat = 70
        addCityName(dictionary: dictionary, position: &y)
        addWeathermain(dictionary: dictionary, withPosition: &y)
        addWeatherIcon(dictionary: dictionary, withPosition: y)
        addMainTemp(dictionary: dictionary, withPosition: &y)
        
        addLine(position: &y)
        addWeatherDescription(dictionary: dictionary, withPosition: &y)
        addCitySunriseAndSunset(dictionary: dictionary, withPosition: &y)
        addHumidity(dictionary: dictionary, withPosition: &y)
        addWindSpeed(dictionary: dictionary, withPosition: &y)
        addWeatherPressure(dictionary: dictionary, withPosition: &y)
        
        // get daily max and min temp
        let client = DailyForecastClient(urlString: "http://api.openweathermap.org/data/2.5/forecast?", appID: "\(ServiceKey.OpenWeatherMap.rawValue)", units: Units.metric)
        client.requestDailyWeatherForecast(city: city!, days: 5) { (result) in
            if result != nil && result!.count > 0{
                if let times = result!.value(forKeyPath: "list.dt_txt") as? [String]{
//                    for time in times{
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.timeZone = self.city!.timezone!
//                        dateFormatter.dateFormat = "dd/MM/yyyy"
//                        
//                        let day = Date.init(timeIntervalSince1970: TimeInterval("\(time)")!)
//                        print(dateFormatter.string(from: day))
//                    }
                    for time in times{
                        print(time)
                    }
                    
                }
            }
        }
    }
    
    // TODO: 1. city.name City name
    private func addCityName(dictionary: NSDictionary, position y: inout CGFloat){
        //city.name City name
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.name.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 30))
            labelText.font = UIFont.systemFont(ofSize: 25)
            labelText.textAlignment = .center
            labelText.text = "\(str)  \(city!.country!.nationalFlag)"
            view.addSubview(labelText)
            y = y + 30
        }
    }
    
    // TODO: 2. Group of weather parameters (Rain, Snow, Extreme etc.)
    private func addWeathermain(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.weathermain.rawValue)"){
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
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.maintemp.rawValue)"){
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
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.weathericon.rawValue)"){
            let weatherConditionClient = WeatherConditionClient()
            weatherConditionClient.requestWeatherIcon(iconID: "\((str as! NSArray)[0])", onComplete: { (data) in
                if data != nil{
                    OperationQueue.main.addOperation({
                        if let image = UIImage(data: data!){
                            let width = UIScreen.main.bounds.size.width
                            let imageView = UIImageView(frame: CGRect(x: width * 0.2, y: y , width: image.size.width, height: image.size.height))
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
    
    private func addWeatherDescription(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.weatherdescription.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labelText = UILabel()
            labelText.numberOfLines = 0
            labelText.text = "Today - \((str as! NSArray)[0])"
            let size = labelText.sizeThatFits(CGSize(width: width * 0.8, height: CGFloat.greatestFiniteMagnitude))
            labelText.frame = CGRect(x: width * 0.1, y: y, width: width * 0.8, height: size.height)
            labelText.textAlignment = .center
            
            view.addSubview(labelText)
            y = y + size.height
        }
    }
    
    private func addCitySunriseAndSunset(dictionary: NSDictionary, withPosition y: inout CGFloat){
        var sunrise : Date?
        var sunset : Date?
        
        let width = UIScreen.main.bounds.size.width
        
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.syssunrise.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Sunrise: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            sunrise = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
            
            if city!.timezone != nil{
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = city!.timezone!
                dateFormatter.dateFormat = "HH:mm"
                labelText.text = "  \(dateFormatter.string(from: sunrise!))"
                view.addSubview(labelText)
            }
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.syssunset.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Sunset: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            sunset = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
            if city!.timezone != nil{
                let dateFormatter = DateFormatter()
                dateFormatter.timeZone = city!.timezone!
                dateFormatter.dateFormat = "HH:mm"
                labelText.text = "  \(dateFormatter.string(from: sunset!))"
                view.addSubview(labelText)
            }
            y = y + 20
        }
        
//        if sunrise != nil && sunset != nil{
//            if Date() > sunrise! && Date() < sunset!{
//                view.backgroundColor = UIColor(red: 16 / 255.0, green: 230 / 255.0, blue: 208 / 255.0, alpha: 1.0)
//            }else{
//                view.backgroundColor = UIColor.darkGray
//            }
//        }
    }
    
    private func addHumidity(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.mainhumidity.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Humidity: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            if let humidity = Int("\(str)"){
                labelText.text = "  \(humidity)%"
            }
            
            view.addSubview(labelText)
            y = y + 20
        }
    }
    
    private func addWindSpeed(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.windspeed.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Wind speed: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
            let symbol = city!.units! == Units.metric ? "\(UnitSpeed.metersPerSecond.symbol)" : "\(UnitSpeed.milesPerHour.symbol)"
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
    }
    
    private func addWeatherPressure(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.mainpressure.rawValue)"){
            let width = UIScreen.main.bounds.size.width
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Pressure: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(UnitPressure.hectopascals.symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
    }
    
    private func addMaxTemp(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "max"){
            let width = UIScreen.main.bounds.size.width
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Max Temp: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
    }
    
    private func addMinTemp(dictionary: NSDictionary, withPosition y: inout CGFloat){
        if let str = dictionary.value(forKeyPath: "min"){
            let width = UIScreen.main.bounds.size.width
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "Min Temp: "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(symbol)"
            view.addSubview(labelText)
            y = y + 20
        }
    }
    
    private func configureView1(){
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
        
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.cod.rawValue)"){
//            print(str)
//        }
        
        addWeatherDescription(dictionary: dictionary, withPosition: &y)
        
        
        
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.weatherdescription.rawValue)"){
//            let labelText = UILabel()
//            labelText.numberOfLines = 0
//            labelText.text = "Today - \((str as! NSArray)[0])"
//            let size = labelText.sizeThatFits(CGSize(width: width * 0.8, height: CGFloat.greatestFiniteMagnitude))
//            labelText.frame = CGRect(x: width * 0.1, y: y, width: width * 0.8, height: size.height)
//            labelText.textAlignment = .center
//            
//            view.addSubview(labelText)
//            y = y + size.height
//        }
        
        let line2 = UIView(frame: CGRect(x: 0, y: y + 3, width: width, height: 1))
        line2.backgroundColor = UIColor.lightGray
        view.addSubview(line2)
        
        y = y + 6
        
//        var sunrise : Date?
//        var sunset : Date?
//        
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.syssunrise.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "Sunrise: "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
//            
//            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//            sunrise = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
//            
//            if city!.timezone != nil{
//                let dateFormatter = DateFormatter()
//                dateFormatter.timeZone = city!.timezone!
//                dateFormatter.dateFormat = "HH:mm"
//                labelText.text = "  \(dateFormatter.string(from: sunrise!))"
//                view.addSubview(labelText)
//            }
//            y = y + 20
//        }
//        
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.syssunset.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "Sunset: "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
//            
//            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//            sunset = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
//            if city!.timezone != nil{
//                let dateFormatter = DateFormatter()
//                dateFormatter.timeZone = city!.timezone!
//                dateFormatter.dateFormat = "HH:mm"
//                labelText.text = "  \(dateFormatter.string(from: sunset!))"
//                view.addSubview(labelText)
//            }
//            y = y + 20
//        }
        
//        if sunrise != nil && sunset != nil{
//            if Date() > sunrise! && Date() < sunset!{
//                view.backgroundColor = UIColor(red: 16 / 255.0, green: 230 / 255.0, blue: 208 / 255.0, alpha: 1.0)
//            }else{
//                view.backgroundColor = UIColor.darkGray
//            }
//        }
        
        addHumidity(dictionary: dictionary, withPosition: &y)
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.mainhumidity.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "Humidity: "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
//            
//            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//            if let humidity = Int("\(str)"){
//                labelText.text = "  \(humidity)%"
//            }
//            
//            view.addSubview(labelText)
//            y = y + 20
//        }
        
        addWindSpeed(dictionary: dictionary, withPosition: &y)
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.windspeed.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "Wind speed: "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
//            
//            // Wind speed. Unit Default: meter/sec, Metric: meter/sec, Imperial: miles/hour.
//            let symbol = city!.units! == Units.metric ? "\(UnitSpeed.metersPerSecond.symbol)" : "\(UnitSpeed.milesPerHour.symbol)"
//            
//            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//            labelText.text = "  \(str) \(symbol)"
//            view.addSubview(labelText)
//            y = y + 20
//        }
        
        addWeatherPressure(dictionary: dictionary, withPosition: &y)
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.mainpressure.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "Pressure: "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
//
//            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//            labelText.text = "  \(str) \(UnitPressure.hectopascals.symbol)"
//            view.addSubview(labelText)
//            y = y + 20
//        }
        
        addMaxTemp(dictionary: dictionary, withPosition: &y)
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.maintemp_max.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "Max Temp: "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
//            
//            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
//            
//            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//            labelText.text = "  \(str) \(symbol)"
//            view.addSubview(labelText)
//            y = y + 20
//        }
        
        addMinTemp(dictionary: dictionary, withPosition: &y)
//        if let str = dictionary.value(forKeyPath: "\(WeatherKeypath.maintemp_min.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "Min Temp: "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
//            
//            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
//            
//            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//            labelText.text = "  \(str) \(symbol)"
//            view.addSubview(labelText)
//            y = y + 20
//        }
        
        
        for subview in view.subviews{
            if subview is UILabel{
                (subview as! UILabel).textColor = UIColor.white
            }
        }
    }
}
