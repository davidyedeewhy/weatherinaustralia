//
//  CityWeatherViewController.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import UIKit

enum Weather : String{
    case base = "base"
    case id = "id"
    case dt = "dt"
    case mainhumidity = "main.humidity"
    case maintemp_max = "main.temp_max"
    case maintemp_min = "main.temp_min"
    case maintemp = "main.temp"
    case mainpressure = "main.pressure"
    case coordlon = "coord.lon"
    case coordlat = "coord.lat"
    case windspeed = "wind.speed"
    case winddeg = "wind.deg"
    case sysid = "sys.id"
    case sysmessage = "sys.message"
    case syscountry = "sys.country"
    case systype = "sys.type"
    case syssunset = "sys.sunset"
    case syssunrise = "sys.sunrise"
    case weatherid = "weather.id"
    case weathermain = "weather.main"
    case weathericon = "weather.icon"
    case weatherdescription = "weather.description"
    case visibility = "visibility"
    case cloudsall = "clouds.all"
    case cod = "cod"
    case name = "name"
}

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
        let width = UIScreen.main.bounds.size.width
        
        if let str = dictionary.value(forKeyPath: "\(Weather.name.rawValue)"){
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 30))
            labelText.font = UIFont.systemFont(ofSize: 25)
            labelText.textAlignment = .center
            labelText.text = "\(str)"
            view.addSubview(labelText)
            y = y + 30
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.weathermain.rawValue)"){
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 22))
            labelText.font = UIFont.systemFont(ofSize: 19)
            labelText.textAlignment = .center
            labelText.text = "\((str as! NSArray)[0])"
            view.addSubview(labelText)
            y = y + 22
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.maintemp.rawValue)"){
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 50))
            labelText.font = UIFont.systemFont(ofSize: 48, weight: 0.1)
            labelText.textAlignment = .center
            
            let temp = String(format: "%.0f", arguments: [Double("\(str)")!])
            let attributedText = NSMutableAttributedString(string: "\(temp)\(city!.tempSymbol!)")
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 48)], range: NSMakeRange(0, "\(temp)".characters.count))
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSBaselineOffsetAttributeName:22], range: NSMakeRange("\(temp)".characters.count,city!.tempSymbol!.characters.count))
            labelText.attributedText = attributedText
            
            view.addSubview(labelText)
            y = y + 50
        }
        
        let line1 = UIView(frame: CGRect(x: 0, y: y, width: width, height: 1))
        line1.backgroundColor = UIColor.lightGray
        view.addSubview(line1)
        
        y = y + 6
        
        if let str = dictionary.value(forKeyPath: "\(Weather.weatherdescription.rawValue)"){
//            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//            labeltTitle.text = "\(Weather.weatherdescription): "
//            labeltTitle.textAlignment = .right
//            view.addSubview(labeltTitle)
            
            let labelText = UILabel()
            labelText.numberOfLines = 0
            //labelText.frame = CGRect(x: width * 0.1, y: y, width: width * 0.8, height: CGFloat.greatestFiniteMagnitude)
            // UILabel(frame: CGRect(x: width * 0.1, y: y, width: width * 0.8, height: 20))
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"

        
        if let str = dictionary.value(forKeyPath: "\(Weather.syssunrise.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.syssunrise): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            let date = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
            labelText.text = "  \(dateFormatter.string(from: date))"
            view.addSubview(labelText)
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.syssunset.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.syssunset): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            let date = Date.init(timeIntervalSince1970: TimeInterval("\(str)")!)
            labelText.text = "  \(dateFormatter.string(from: date))"
            view.addSubview(labelText)
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.mainhumidity.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.mainhumidity): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str)%"
            view.addSubview(labelText)
            y = y + 20
        }
        
        if let str = dictionary.value(forKeyPath: "\(Weather.windspeed.rawValue)"){
            let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
            labeltTitle.text = "\(Weather.windspeed): "
            labeltTitle.textAlignment = .right
            view.addSubview(labeltTitle)
            
            let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
            labelText.text = "  \(str) \(UnitSpeed.kilometersPerHour.symbol)"
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
        
//        var keypaths = [String]()
//
//
//        for key in dictionary.allKeys{
//
//
//            if let object = dictionary.object(forKey: "\(key)") as? NSArray{
//                if object.count > 0{
//                    if let dictionary1 = object[0] as? NSDictionary{
//                        for key1 in dictionary1.allKeys{
//                            if let object1 = dictionary1.object(forKey: "\(key1)"){
//                                let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                                labeltTitle.text = "\(key).\(key1): "
//                                labeltTitle.textAlignment = .right
//                                view.addSubview(labeltTitle)
//                                
//                                let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                                labelText.text = " \(object1)"
//                                view.addSubview(labelText)
//                                y = y + 20
//
//                                keypaths.append("\(key)\(key1) = \"\(key).\(key1)\"")
//                            }
//                        }
//                    }
//                }
//                
////
////                print(_obj!);
//                //var array = swiftarray.map({$0["key.path"]! as ObjectType})
//            }else if let object = dictionary.object(forKey: "\(key)") as? NSDictionary{
//                for key2 in object.allKeys{
//                    if let object2 = object.object(forKey: "\(key2)"){
//                        let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                        labeltTitle.text = "\(key).\(key2): "
//                        labeltTitle.textAlignment = .right
//                        view.addSubview(labeltTitle)
//                        
//                        let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                        labelText.text = " \(object2)"
//                        view.addSubview(labelText)
//                        y = y + 20
//                        
//                        keypaths.append("\(key)\(key2) = \"\(key).\(key2)\"")
//                    }
//                }
//                
//            }else if let object = dictionary.object(forKey: "\(key)"){
//                let labeltTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labeltTitle.text = "\(key): "
//                labeltTitle.textAlignment = .right
//                view.addSubview(labeltTitle)
//                
//                let labelText = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelText.text = " \(object)"
//                view.addSubview(labelText)
//                y = y + 20
//
//                keypaths.append("\(key) = \"\(key)\"")
//            }
//        }
//        
//        for keypath in keypaths{
//            print("case \(keypath)")
//        }
        //case metric = "metric"
        
        
        
//        if city != nil{
//            if city!.weatherSys != nil{
//                let labelSunriseTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelSunriseTitle.text = "Sunrise: "
//                labelSunriseTitle.textAlignment = .right
//                view.addSubview(labelSunriseTitle)
//                
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "HH:mm"
//
//                let labelSunrise = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelSunrise.text = " \(dateFormatter.string(from: city!.weatherSys!.sunrise))"
//                view.addSubview(labelSunrise)
//                
//                y = y + 20
//                
//                let labelSunsetTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelSunsetTitle.text = "Sunset: "
//                labelSunsetTitle.textAlignment = .right
//                view.addSubview(labelSunsetTitle)
//                
//                let labelSunset = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelSunset.text = " \(dateFormatter.string(from: city!.weatherSys!.sunset))"
//                view.addSubview(labelSunset)
//
//                y = y + 20
//            }
//            
//            if city!.cloud != nil{
//                let labelCloudsTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelCloudsTitle.text = "Clouds: "
//                labelCloudsTitle.textAlignment = .right
//                view.addSubview(labelCloudsTitle)
//                
//                let labelpressure = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelpressure.text = String(format: " %.0f%@", arguments: [city!.cloud!.all, "%"])
//                view.addSubview(labelpressure)
//                
//                y = y + 20
//            }
//            
//            if city!.weather != nil{
//                let labelHumidityTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelHumidityTitle.text = "Humidity: "
//                labelHumidityTitle.textAlignment = .right
//                view.addSubview(labelHumidityTitle)
//                
//                let labelHumidity = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelHumidity.text = String(format: " %.0f%@", arguments: [city!.weather!.humidity, "%"])
//                view.addSubview(labelHumidity)
//                
//                y = y + 20
//                
//                let labelpressureTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelpressureTitle.text = "Pressure: "
//                labelpressureTitle.textAlignment = .right
//                view.addSubview(labelpressureTitle)
//                
//                let labelpressure = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelpressure.text = String(format: " %.0f", arguments: [city!.weather!.pressure])
//                view.addSubview(labelpressure)
//                
//                y = y + 20
//            }
//            
//            if city!.wind != nil{
//                let labelDegTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelDegTitle.text = "deg: "
//                labelDegTitle.textAlignment = .right
//                view.addSubview(labelDegTitle)
//                
//                let labelDeg = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelDeg.text = String(format: " %.0f", arguments: [city!.wind!.deg])
//                view.addSubview(labelDeg)
//                
//                y = y + 20
//                
//                let labelSpeedTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelSpeedTitle.text = "Speed: "
//                labelSpeedTitle.textAlignment = .right
//                view.addSubview(labelSpeedTitle)
//                
//                let labelpressure = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelpressure.text = String(format: " %.0f", arguments: [city!.wind!.speed])
//                view.addSubview(labelpressure)
//                
//                y = y + 20
//            }
//            
//            if city!.weatherMain != nil{
//                let labelTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelTitle.text = "Description: "
//                labelTitle.textAlignment = .right
//                view.addSubview(labelTitle)
//                
//                let label = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                label.text = String(format: " %.0f", arguments: [city!.weatherMain!.mainDescription])
//                view.addSubview(label)
//                
//                y = y + 20
//                
//                let labelSpeedTitle = UILabel(frame: CGRect(x: 0, y: y, width: width * 0.5, height: 20))
//                labelSpeedTitle.text = "Main: "
//                labelSpeedTitle.textAlignment = .right
//                view.addSubview(labelSpeedTitle)
//                
//                let labelpressure = UILabel(frame: CGRect(x: width * 0.5, y: y, width: width * 0.5, height: 20))
//                labelpressure.text = String(format: " %.0f", arguments: [city!.weatherMain!.main])
//                view.addSubview(labelpressure)
//                
//                y = y + 20
//            }
//        }
    }
}
