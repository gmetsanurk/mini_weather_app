//
//  Untitled.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//
import Foundation

protocol WeatherAPIClientProtocol {
    func fetchWeather(lat: Double, lon: Double, days: Int, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

class WeatherAPIClient: WeatherAPIClientProtocol {
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    private let baseURL = "https://api.weatherapi.com/v1"

    func fetchWeather(lat: Double, lon: Double, days: Int = 7, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=\(days)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error)); return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0))); return
            }
            do {
                let decoder = JSONDecoder()
                // API time strings in 'yyyy-MM-dd HH:mm' format
                decoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)
                let response = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
