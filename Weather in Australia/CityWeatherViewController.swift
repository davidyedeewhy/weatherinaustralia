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
        let width = UIScreen.main.bounds.size.width
        
        //city.name City name
        if let str = dictionary.value(forKeyPath: "\(Weather.name.rawValue)"){
            let labelText = UILabel(frame: CGRect(x: 0, y: y, width: width, height: 30))
            labelText.font = UIFont.systemFont(ofSize: 25)
            labelText.textAlignment = .center
            labelText.text = "\(str)"
            view.addSubview(labelText)
            y = y + 30
        }
        
        //Group of weather parameters (Rain, Snow, Extreme etc.)
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
            
            let symbol = city!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            
            let attributedText = NSMutableAttributedString(string: "\(temp)\(symbol)")
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 48)], range: NSMakeRange(0, "\(temp)".characters.count))
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17), NSBaselineOffsetAttributeName:22], range: NSMakeRange("\(temp)".characters.count,symbol.characters.count))
            labelText.attributedText = attributedText
            
            view.addSubview(labelText)
            y = y + 50
        }
        
        let line1 = UIView(frame: CGRect(x: 0, y: y, width: width, height: 1))
        line1.backgroundColor = UIColor.lightGray
        view.addSubview(line1)
        
        y = y + 6
        
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
    }
}
