//
//  WeatherAPIClient.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import Foundation
import UIKit

protocol WeatherAPIClientProtocol {
    func fetchWeather(lat: Double, lon: Double, days: Int, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
    func fetchIcon(path: String, completion: @escaping (UIImage?) -> Void)
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
                decoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)
                let response = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchIcon(path: String, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https:" + path
        guard let url = URL(string: urlString) else {
            completion(nil); return
        }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil); return
            }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
