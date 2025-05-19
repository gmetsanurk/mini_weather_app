//
//  Models.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
}

struct Location: Codable {
    let name: String?
    let region: String?
    let country: String?
}

struct CurrentWeather: Codable {
    let temp_c: Double?
    let condition: Condition
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String?
    let hour: [HourlyWeather]
    let day: DayWeather
}

struct HourlyWeather: Codable {
    let time: String?
    let temp_c: Double?
    let condition: Condition
}

struct DayWeather: Codable {
    let maxtemp_c: Double?
    let mintemp_c: Double?
    let condition: Condition
}

struct Condition: Codable {
    let text: String?
    let icon: String?
}
