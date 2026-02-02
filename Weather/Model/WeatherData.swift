//
//  WeatherData.swift
//  Weather
//
//  Created by Sanyukta Adhate on 01/02/26.
//
//`Codable` is a type alias for the `Encodable` and `Decodable` protocols. Must same as JSON

struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Weather: Codable {
    let id: Int
}

struct Main: Codable {
    let temp: Double
}
