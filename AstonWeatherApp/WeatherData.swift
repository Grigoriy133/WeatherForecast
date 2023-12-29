//
//  WeatherDAta.swift
//  AstonWeatherApp
//
//  Created by Гриша  on 27.12.2023.
//
import Foundation
struct ForecastWeatherData: Codable {
    let dt: Int
    let main: WeatherData
    let weather: [WeatherCondition]
}
struct ForecastResponse: Codable {
    let list: [ForecastWeatherData]
}
struct DailyWeather {
    let date: Date
    let weatherData: [ForecastWeatherData]
}

