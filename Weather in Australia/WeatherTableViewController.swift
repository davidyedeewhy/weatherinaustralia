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
    
    private var cities : [City]?
    private let cityIDs = [4163971, 2147714, 2174003]
    private var activityIndicator : UIActivityIndicatorView?

    // MARK: - view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(requestWeathers), for: .valueChanged)
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator?.center = CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: UIScreen.main.bounds.size.height / 2.0)
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        
        // MARK: load city weathers
        requestWeathers(sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "WeatherLoadingFinish"), object: nil, queue: OperationQueue.main) { (notification) in
            self.refreshControl?.endRefreshing()
            self.activityIndicator?.stopAnimating()
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - functions
    @objc private func requestWeathers(sender: AnyObject?){
        cities = [City]()
        requestWeatherForCityIndex(index: 0)
    }
    
    private func requestWeatherForCityIndex(index: Int){
        if index < cityIDs.count{
            let weatherClient = CurrentWeatherClient(urlString: "http://api.openweathermap.org/data/2.5/weather?", appID: "3fe25736cbd429e82dd9abb3afca0002", units: Units.metric)
            weatherClient.requestWeather(cityId: cityIDs[index], onComplete: { (city) in
                if city != nil && self.cities!.contains(city!) == false{
                    self.cities!.append(city!)
                    self.requestWeatherForCityIndex(index: index + 1)
                }
                self.requestWeatherForCityIndex(index: index + 1)
            })
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WeatherLoadingFinish"), object: nil)
        }
    }

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
        
        if city.weather != nil{
            let attributedText = NSMutableAttributedString(string: "\(city.weather!.temp)\(city.weather!.tempSymbol)")
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17)], range: NSMakeRange(0, "\(city.weather!.temp)".characters.count))
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSBaselineOffsetAttributeName:7], range: NSMakeRange("\(city.weather!.temp)".characters.count,2))
            cell.detailTextLabel?.attributedText = attributedText
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cities![indexPath.row]
        let cityWeatherController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CityWeatherViewController") as! CityWeatherViewController
        cityWeatherController.city = city
        navigationController?.pushViewController(cityWeatherController, animated: true)
    }

}
