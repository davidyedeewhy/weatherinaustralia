//
//  WeatherTableViewController.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    // MARK: - properties
    
    private var cities : [Weather]?
    private let cityIDs = [4163971, 2147714, 2174003]

    // MARK: - view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(requestWeathers), for: .valueChanged)
        
        // MARK: load city weathers
        requestWeathers(sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - functions
    @objc private func requestWeathers(sender: AnyObject?){
        if cities == nil{
            cities = [Weather]()
        }
        
        let weatherClient = WeatherClient(urlString: "http://api.openweathermap.org/data/2.5/weather?", appID: "3fe25736cbd429e82dd9abb3afca0002", units: "metric")
        for cityID in cityIDs {
            weatherClient.requestWeather(cityId: cityID, onComplete: { (weather) in
                if weather != nil && self.cities!.contains(weather!) == false{
                    self.cities!.append(weather!)
                    
                    self.cities?.sort(by: { (city1, city2) -> Bool in
                        return city1.cityId < city2.cityId
                    })
                    
                    OperationQueue.main.addOperation({
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    
//    private func requestWeatherForCity(cityIndex: Int){
//        if cityIndex < cityIDs.count{
//            let weatherClient = WeatherClient(urlString: "http://api.openweathermap.org/data/2.5/weather?", appID: "3fe25736cbd429e82dd9abb3afca0002", units: "metric")
//            weatherClient.requestWeather(cityId: cityIDs[cityIndex], onComplete: { (weather) in
//                if weather != nil && self.cities!.contains(weather!) == false{
//                    self.cities!.append(weather!)
//                    
//                    self.cities?.sort(by: { (city1, city2) -> Bool in
//                        return city1.cityId < city2.cityId
//                    })
//                    
//                    OperationQueue.main.addOperation({
//                        self.tableView.reloadData()
//                        self.requestWeatherForCity(cityIndex: cityIndex + 1)
//                    })
//                }
//            })
//        }else{
//            if self.refreshControl?.isRefreshing == true{
//                self.refreshControl?.endRefreshing()
//            }
//        }
//    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities != nil ? cities!.count : 0
    }

    // MARK: - Table view delegates
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)

        let city = cities![indexPath.row]
        cell.textLabel?.text = "\(city.name!)"
        
        let attributedText = NSMutableAttributedString(string: "\(city.temp!)℃")
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17)], range: NSMakeRange(0, "\(city.temp!)".characters.count))
        attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 8), NSBaselineOffsetAttributeName:7], range: NSMakeRange("\(city.temp!)".characters.count,1))
        cell.detailTextLabel?.attributedText = attributedText
        
        
        
        return cell
    }

}
