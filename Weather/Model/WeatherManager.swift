//
//  WeatherModel.swift
//  Weather
//
//  Created by Sanyukta Adhate on 30/01/26.
//

import Foundation
import CoreLocation

//1> If you use me, you MUST handle these callbacks.
protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let baseURL = "https://api.openweathermap.org/data/2.5/weather?&appid=b83132a4d79477145379d3f4c36a8148&units=metric"
    
    //2> Delegate property - idk who calling but whoever it is must follow rules, ? unassigned yet.
    var delegate: WeatherManagerDelegate?
    
    //method overloading
    //Fetch by city
    func fetchWeather(cityName: String){
        let urlString = "\(baseURL)&q=\(cityName)"
        print(urlString)
        handleRequest(urlString)
    }
    //Fetch by location - latitude, longitude
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(baseURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        handleRequest(urlString)
    }
    
        //we have to handle optional here - force unwrap
    func handleRequest(_ urlString: String) {
            //1. Create a URL
        if let url = URL(string: urlString) {
                //2. Create a URL session
            let session = URLSession(configuration: .default)
                //3. Give URL session a task - Internet call. Turns raw JSON → structs
            let task = session.dataTask(with: url) { (data, response, error) in
                if (error != nil){
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    if let dataStr = String(data: safeData, encoding: .utf8) {
//                        print(dataStr)
//                        self.parseJSONData(weatherData: safeData)
//                    }
                    if let parsedWeather = self.parseJSONData(safeData) {
                        //5> Delegate call
                        self.delegate?.didUpdateWeather(self, weather: parsedWeather)
                    }
                }
                
            }
                //4. Initiate a task
            task.resume()
        }
    }
    
    func parseJSONData(_ weatherData: Data) -> WeatherModel? {
        do{
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: weatherData)
            
            let conditionId = decodedData.weather[0].id
            print("Condition Id: ", conditionId)
            
            let temperature = decodedData.main.temp
            print("Temperature: ", temperature)
            
            let cityName = decodedData.name
            print("City name: ", cityName)
            
            let weather = WeatherModel(conditionId: conditionId, temperature: temperature, cityName: cityName)
            print(weather.temperatureString)
            print(weather.conditionName)
            
            return weather
        }   catch { self.delegate?.didFailWithError(error: error); return nil }
    }
    
}

