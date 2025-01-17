//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    @IBOutlet weak var faren: UISwitch!
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "324d2a86423fab8ed7db037b70c12c61"
    
    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    var celOrFar : Bool = false
    
    @IBAction func weatherChange(_ sender: UISwitch)
    {
        if sender.isOn == true
        {
            celOrFar = true
            
        }
        if sender.isOn == false
        {
            celOrFar = false
        }
        
        updateUIWithWeatherData()
        
    }
    
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    @IBOutlet weak var button: UIButton!
    
    fileprivate func settingUpLocationManager() {
        //TODO:Set up the location manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        settingUpLocationManager()
        
    }
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess
            {
                
                print("Success! Got the weather data")
                let weatherJSON : JSON = JSON(response.result.value!)
                
                print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            }
            else
            {
                print("Error \(String(describing: response.result.error))")
                self.cityLabel.text = "Connection Issues"
            }
        }
        
    }
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json : JSON)
    {
        
        if let tempResult = json["main"]["temp"].double
        {
        
            print(tempResult)
            
            if celOrFar == false
            {
                weatherDataModel.tamperature = Int(tempResult - 273.15)
            }
            else if celOrFar == true
            {
                weatherDataModel.tamperature = Int((tempResult - 273.15) * 9/5 + 32)
            }
            
            weatherDataModel.city = json["name"].stringValue
            
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()

        }
        else
        {
            cityLabel.text = "Weather Unavailable"
        }
    }
     
     
     
     
     //MARK: - UI Updates
     /***************************************************************/

     //Write the updateUIWithWeatherData method here:
    
    func updateUIWithWeatherData()
    {
        cityLabel.text = weatherDataModel.city
        if celOrFar == false
        {
            temperatureLabel.text = "\(weatherDataModel.tamperature)°c"
        }
        else if celOrFar == true
        {
            temperatureLabel.text = "\(weatherDataModel.tamperature * 9/5 + 32)℉"
        }
        
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
 

    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            self.locationManager.stopUpdatingLocation()
            
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    
    

    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    //Write the userEnteredANewCityName Delegate method here:
    func userEnteredANewCityName(city: String)
    {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "changeCityName"
        {
            let destinationVC = segue.destination as! ChangeCityViewController
            
            destinationVC.delegate = self
        }
    }
    
}











