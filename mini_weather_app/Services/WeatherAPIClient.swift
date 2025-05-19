//
//  WeatherAPIClient.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case badStatus(code: Int)
    case noData
}

protocol WeatherAPIClientProtocol {
    func fetchWeather(
        lat: Double,
        lon: Double,
        days: Int
    ) async throws -> WeatherResponse

    func fetchIconData(path: String) async throws -> Data
}

final class WeatherAPIClient: WeatherAPIClientProtocol {
    private let apiKey: String
    private let baseURL: URL
    private let session: URLSession

    init(
        apiKey: String = "fa8b3df74d4042b9aa7135114252304",
        baseURL: URL = URL(string: "https://api.weatherapi.com/v1")!,
        session: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.session = session
    }

    private func makeForecastURL(
        lat: Double,
        lon: Double,
        days: Int
    ) -> URL? {
        var components = URLComponents(url: baseURL.appendingPathComponent("forecast.json"), resolvingAgainstBaseURL: false)
        components?.queryItems = [
            .init(name: "key", value: apiKey),
            .init(name: "q", value: "\(lat),\(lon)"),
            .init(name: "days", value: "\(days)")
        ]
        return components?.url
    }

    func fetchWeather(
        lat: Double,
        lon: Double,
        days: Int = 7
    ) async throws -> WeatherResponse {
        guard let url = makeForecastURL(lat: lat, lon: lon, days: days) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse else {
            throw APIError.badStatus(code: -1)
        }
        guard 200..<300 ~= http.statusCode else {
            throw APIError.badStatus(code: http.statusCode)
        }
        guard !data.isEmpty else {
            throw APIError.noData
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.apiDateFormatter)
        return try decoder.decode(WeatherResponse.self, from: data)
    }

    func fetchIconData(path: String) async throws -> Data {
        let urlString = "https:" + path
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw APIError.badStatus(code: (response as? HTTPURLResponse)?.statusCode ?? -1)
        }
        guard !data.isEmpty else {
            throw APIError.noData
        }
        return data
    }
}
