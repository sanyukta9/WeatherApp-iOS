//
//  ViewController.swift
//  Weather
//
//  Created by Sanyukta Adhate on 29/01/26.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var conditionWeather: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    //when click on go button
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
        print(searchField.text!)
    }
    //when click on live button
    @IBAction func liveLocation(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager() //holds the current GPS of the phone
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupDelegates()
        setupLocation()
    }
}
    
    //MARK: - Setup
extension ViewController {
    //set as delegate
    func setupDelegates() {
        searchField.delegate = self
        weatherManager.delegate = self
        locationManager.delegate = self
    }
    //A screen prompt requests the user’s permission to grant live location access
    func setupLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}
    
    //MARK: - UITextFieldDelegate

    //when click on search button, it will print the location
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        print(searchField.text!)
        return true
        
    }
    
        //clear the search field once done typed n searching
        //pass on the city name the openWeather api, fetch the url which returns response
    func textFieldDidEndEditing(_ textField: UITextField) {
        let city = searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !city.isEmpty {
            weatherManager.fetchWeather(cityName: city)
        }
        searchField.text = ""
    }
    
        //handled edge case: searchField should not be empty
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else{
            textField.placeholder = "Please enter a city name"
            return false
        }
    }
}

    //MARK: - WeatherManagerDelegate

extension ViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager ,weather: WeatherModel){
            //long running tasks such as networking are executed in background, wont update UI from a completion handler. Dispatch the call to update the label text to the main thread.
            //wrap the UI update code inside the DispatchQueue block
        DispatchQueue.main.async {
            print("didUpdateWeather called:", weather.cityName)
            self.temperatureLabel.text = weather.temperatureString
            self.conditionWeather.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

    //MARK: - CLLocationManagerDelegate

   //must implement both methods else app crashes
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Showing live location")
        guard let location = locations.last else { return }
        locationManager.stopUpdatingLocation()
        weatherManager.fetchWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}

