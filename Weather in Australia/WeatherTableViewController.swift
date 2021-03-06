//
//  WeatherTableViewController.swift
//  Weather in Australia
//
//  Created by David Ye on 23/1/17.
//  Copyright © 2017 Bestau Pty Ltd. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UITableViewController, CLLocationManagerDelegate {

    // MARK: - properties
    private var locationManager : CLLocationManager?
    private var cities : [City]?
    private let cityIDs = [4163971, 2147714, 2174003, 2158177]//2158177 city ID for Melbourne, AU
    private var activityIndicator : UIActivityIndicatorView?
    private var currenctLocation : CLLocationCoordinate2D?
    private var units : Units? // for the OpenWeatherMap request, default value is metric

    // MARK: - view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // MARK: - functions
    private func configureView(){
        let width = view.bounds.size.width
        let height = view.bounds.size.height
        
        // MARK: 1. add bar button to add local weather
        let btnLocal = UIBarButtonItem(title: "Local", style: .plain, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItems = [btnLocal]
        
        // MARK: 2. setup CLLocationManager
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager?.startUpdatingLocation()
        }
        
        // MARK: 3. setup refreshControl for further weather request
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(requestWeatherForCities), for: .valueChanged)
        
        // MARK: 4. setup activity indicator
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator?.center = CGPoint(x: width / 2.0, y: height / 2.0)
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        
        // MARK: 5. add segment
        let segment = UISegmentedControl(items: ["\(UnitTemperature.celsius.symbol)", "\(UnitTemperature.fahrenheit.symbol)"])
        segment.frame = CGRect(x: 0, y: 0, width: width * 0.5, height: 30)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(didTapUnits), for: .valueChanged)
        navigationItem.titleView = segment
        
        // MARK: 6. initialize collection [City] and load city weathers
        cities = [City]()
        units = Units.metric
        requestWeatherForCities()
    }
    
    @IBAction func didTapAdd(sender: UIBarButtonItem){
        // TODO: request current location weather
        guard let _ = currenctLocation else{
            // do something here
            return
        }
        
        let weatherClient = CurrentWeatherClient(urlString: "\(OpenWeatherMapService.currentWeather.rawValue)", appID: "\(ServiceKey.OpenWeatherMap.rawValue)", units: Units.metric)
        weatherClient.requestWeatherForCurrentLocation(location: currenctLocation!, onComplete: { [weak self](city) in
            guard let city = city else{
                return
            }
            
            if self?.cities?.contains(city) == false{
                self?.cities?.append(city)
                OperationQueue.main.addOperation({
                    self?.tableView.reloadData()
                })
            }
        })
    }
    
    @IBAction func didTapCityName(sender: UIBarButtonItem){
        // MARK: request weather by city name
        let weatherClient = CurrentWeatherClient(urlString: "\(OpenWeatherMapService.currentWeather.rawValue)", appID: "\(ServiceKey.OpenWeatherMap.rawValue)", units: Units.metric)
        weatherClient.requestWeatherForCity(name: "Shenyang,cn", onComplete: { [weak self](city) in
            guard let city = city else{
                return
            }
            
            if self?.cities?.contains(city) == false{
                self?.cities?.append(city)
                OperationQueue.main.addOperation({
                    self?.tableView.reloadData()
                })
            }
        })
    }

    @objc private func requestWeatherForCities(){
        
        let queue = DispatchQueue(label: "weatherRequest")
        var totalRequest = 0
        
        for cityID in self.cityIDs{
            queue.async(execute: { [weak self] in

                let weatherClient = CurrentWeatherClient(urlString: "\(OpenWeatherMapService.currentWeather.rawValue)", appID: "\(ServiceKey.OpenWeatherMap.rawValue)", units: self!.units!)
                weatherClient.requestWeather(cityId: cityID, onComplete: { (city) in
                    if city != nil{
                        if self?.cities!.contains(city!) == false{
                            // MARK: if city collection doesn't contain object, then add to collection
                            self?.cities!.append(city!)
                        }else{
                            // MARK: otherwise, update city's current weather
                            if let existCity = self?.cities!.filter({ (obj) -> Bool in
                                return city == obj
                            }){
                                existCity[0].currentWeather = city!.currentWeather
                            }
                        }

                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            totalRequest += 1
                            
                            if totalRequest == (self?.cityIDs.count)! - 1{
                                self?.refreshControl?.endRefreshing()
                                self?.activityIndicator?.stopAnimating()
                            }
                        }
                    }
                })
            })
        }
    }
    
    private func configureCell(cell: UITableViewCell, forRow indexPath: IndexPath){
        let city = cities![indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(city.name!)\n"
        // MARK: display city's current time according to timezone
        if let timezone = city.timezone {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = timezone
            dateFormatter.dateFormat = "HH:mm"
            // MARK: display country's flag to indicate cities with same name in different country
            cell.textLabel?.text = "\(city.country!.nationalFlag)\(city.name!)\n\(dateFormatter.string(from: Date()))"
            // MARK: add timer to display current time
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                cell.textLabel?.text = "\(city.country!.nationalFlag)\(city.name!)\n\(dateFormatter.string(from: Date()))"
            })
        }else if let location = city.location{
            // MARK: get city's timezone by using Google Map Service
            let client = GoogleMapClient()
            client.requestTimezone(location: location, timestamp: Date(), onComplete: { (timezone) in
                if timezone != nil{
                    city.timezone = timezone
                    OperationQueue.main.addOperation({
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = timezone
                        dateFormatter.dateFormat = "HH:mm"
                        cell.textLabel?.text = "\(city.country!.nationalFlag)\(city.name!)\n\(dateFormatter.string(from: Date()))"
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                            cell.textLabel?.text = "\(city.country!.nationalFlag)\(city.name!)\n\(dateFormatter.string(from: Date()))"
                        })
                    })
                }
            })
        }

        if let temp = city.currentWeather?.temperature{
            let tempString = String(format: "%.0f", arguments: [temp])
            let symbol = city.currentWeather!.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            let attributedText = NSMutableAttributedString(string: "\(tempString)\(symbol)")
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17)], range: NSMakeRange(0, "\(tempString)".characters.count))
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSBaselineOffsetAttributeName:7], range: NSMakeRange("\(tempString)".characters.count,symbol.characters.count))
            cell.detailTextLabel?.attributedText = attributedText
        }
    }
    
    @objc private func didTapUnits(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex{
        case 0:
            units = Units.metric
            break
        case 1:
            units = Units.imperial
            break
        default:
            break
        }
        // MARK: change unit between Metric and Imperial, and make a request to update data
        requestWeatherForCities()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rows = cities?.count else {
            return 0
        }
        return rows
    }

    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        configureCell(cell: cell, forRow: indexPath)
        return cell
    }
    
    // MARK: - prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCityWeather"{
            if let cell = sender as? UITableViewCell{
                if let indexPath = tableView.indexPath(for: cell){
                    let city = cities![indexPath.row]
                    if let cityWeatherController = segue.destination as? CityWeatherViewController{
                        // MARK: setup destination controller's property based on selected cell
                        cityWeatherController.city = city
                    }
                }
            }
        }
    }
    
    // MARK: - CLLocationManager Delegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // MARK: update device's current location
        currenctLocation = manager.location!.coordinate
    }

}
