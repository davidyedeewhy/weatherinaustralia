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
    private let locationManager = CLLocationManager()
    private var cities : [City]?
    private let cityIDs = [4163971, 2147714, 2174003, 2158177]//2158177 city ID for Melbourne, AU
    private var activityIndicator : UIActivityIndicatorView?
    private var currenctLocation : CLLocationCoordinate2D?

    // MARK: - view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. add bar button to add local weather
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navigationItem.rightBarButtonItems = [addButton]
        
        // 2. setup CLLocationManager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.startUpdatingLocation()
        }
        
        // 3. setup refreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(requestWeathers), for: .valueChanged)
        
        // 4. setup activity indicator
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator?.center = CGPoint(x: UIScreen.main.bounds.size.width / 2.0, y: UIScreen.main.bounds.size.height / 2.0)
        view.addSubview(activityIndicator!)
        activityIndicator?.startAnimating()
        
        // 5. initialize collection [City] and load city weathers
        cities = [City]()
        requestWeatherForCityIndex(index: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add observer for update weather finished
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "\(WeatherNotification.WeatherLoadingFinish)"), object: nil, queue: OperationQueue.main) { (notification) in
            self.refreshControl?.endRefreshing()
            self.activityIndicator?.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // remove observer for update weather finished
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "\(WeatherNotification.WeatherLoadingFinish)"), object: nil)
    }
    
    // MARK: - functions
    // request current location weather
    @IBAction func didTapAdd(sender: UIBarButtonItem){
        if currenctLocation != nil{
            let weatherClient = CurrentWeatherClient(urlString: "\(OpenWeatherMapService.currentWeather.rawValue)", appID: "\(ServiceKey.OpenWeatherMap.rawValue)", units: Units.metric)
            weatherClient.requestWeatherForCurrentLocation(location: currenctLocation!, onComplete: { (city) in
                if city != nil && self.cities!.contains(city!) == false{
                    self.cities!.append(city!)
                    OperationQueue.main.addOperation({ 
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    
    @IBAction func didTapCityName(sender: UIBarButtonItem){
        let weatherClient = CurrentWeatherClient(urlString: "\(OpenWeatherMapService.currentWeather.rawValue)", appID: "\(ServiceKey.OpenWeatherMap.rawValue)", units: Units.metric)
        weatherClient.requestWeatherForCity(name: "Shenyang,cn", onComplete: { (city) in
            if city != nil && self.cities!.contains(city!) == false{
                self.cities!.append(city!)
                OperationQueue.main.addOperation({
                    self.tableView.reloadData()
                })
            }
        })
    }
    
    @objc private func requestWeathers(sender: AnyObject?){
        requestWeatherForCityIndex(index: 0)
    }

    // MARK: recursing for update weather for cities
    private func requestWeatherForCityIndex(index: Int){
        if index < cityIDs.count{
            let weatherClient = CurrentWeatherClient(urlString: "\(OpenWeatherMapService.currentWeather.rawValue)", appID: "\(ServiceKey.OpenWeatherMap.rawValue)", units: Units.metric)
            weatherClient.requestWeather(cityId: cityIDs[index], onComplete: { (city) in
                // if city collection doesn't contain object, then add to collection
                if city != nil{
                    if self.cities!.contains(city!) == false{
                        self.cities!.append(city!)
                    }else{
                        
                    }
                }
                self.requestWeatherForCityIndex(index: index + 1)
            })
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "\(WeatherNotification.WeatherLoadingFinish)"), object: nil)
        }
    }
    
    private func configureCell(cell: UITableViewCell, forRow indexPath: IndexPath){
        let city = cities![indexPath.row]
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(city.name!)\n"
        
        if city.timezone != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = city.timezone!
            dateFormatter.dateFormat = "HH:mm"
            cell.textLabel?.text = "\(city.country!.nationalFlag)\(city.name!)\n\(dateFormatter.string(from: Date()))"
        } else if city.location != nil{
            let client = GoogleMapClient()
            client.requestTimezone(location: city.location!, timestamp: Date(), onComplete: { (timezone) in
                if timezone != nil{
                    city.timezone = timezone
                    OperationQueue.main.addOperation({
                        let dateFormatter = DateFormatter()
                        dateFormatter.timeZone = city.timezone!
                        dateFormatter.dateFormat = "HH:mm"
                        cell.textLabel?.text = "\(city.country!.nationalFlag)\(city.name!)\n\(dateFormatter.string(from: Date()))"
                        
                        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                            cell.textLabel?.text = "\(city.country!.nationalFlag)\(city.name!)\n\(dateFormatter.string(from: Date()))"
                        })
                    })
                }
            })
        }
        
        if var temp = city.dictionary!.value(forKeyPath: "main.temp"){
            temp = String(format: "%.0f", arguments: [Double("\(temp)")!])
            let symbol = city.units! == Units.metric ? "\(UnitTemperature.celsius.symbol)" : "\(UnitTemperature.fahrenheit.symbol)"
            let attributedText = NSMutableAttributedString(string: "\(temp)\(symbol)")
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 17)], range: NSMakeRange(0, "\(temp)".characters.count))
            attributedText.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: 10), NSBaselineOffsetAttributeName:7], range: NSMakeRange("\(temp)".characters.count,symbol.characters.count))
            cell.detailTextLabel?.attributedText = attributedText
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
        currenctLocation = manager.location!.coordinate
        print("locations = \(currenctLocation!.latitude) \(currenctLocation!.longitude)")
    }

}
