//
//  WeatherModel.swift
//  Weather
//
//  Created by Sanyukta Adhate on 01/02/26.
//
//This is what UI actually uses.

import Foundation
struct WeatherModel {
    let conditionId: Int
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    let cityName: String
    
    var conditionName: String {
        switch conditionId {
            case 200...232:
                return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "cloud.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }
}
