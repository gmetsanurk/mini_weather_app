//
//  eatherPresenter.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import Foundation

enum WeatherDisplayItem {
    case current(CurrentWeather, locationName: String)
    case hourly(HourlyWeather)
    case daily(ForecastDay)
}

protocol WeatherViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showWeather(_ response: WeatherResponse)
}

protocol WeatherPresenterProtocol {
    func viewDidLoad()
    func retry()
}

class WeatherPresenter: WeatherPresenterProtocol {
    weak var view: WeatherViewProtocol?
    private let apiClient: WeatherAPIClientProtocol
    private let locationService: LocationServiceProtocol
    var weatherResponse: WeatherResponse?

    var currentLat: Double = 0
    var currentLon: Double = 0

    init(apiClient: WeatherAPIClientProtocol, locationService: LocationServiceProtocol) {
        self.apiClient = apiClient
        self.locationService = locationService
    }

    func viewDidLoad() {
        view?.showLoading()
        locationService.requestLocation { [weak self] coord in
            guard let self = self else { return }
            self.currentLat = coord.latitude
            self.currentLon = coord.longitude
            self.fetchWeather()
        }
    }

    func retry() {
        view?.showLoading()
        fetchWeather()
    }

    private func fetchWeather() {
        apiClient.fetchWeather(lat: currentLat, lon: currentLon, days: 7) { [weak self] result in
            DispatchQueue.main.async {
                self?.view?.hideLoading()
                switch result {
                case .success(let response):
                    self?.view?.showWeather(response)
                case .failure(let error):
                    self?.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}

extension WeatherPresenter {
    private typealias FR = ForecastDay
    private typealias HR = HourlyWeather

    var sectionCount: Int {
        weatherResponse == nil ? 0 : 3
    }

    func numberOfRows(in section: Int) -> Int {
        guard let resp = weatherResponse else { return 0 }
        switch section {
        case 0: return 1
        case 1:
            let now = Date()
            let today = resp.forecast.forecastday.first?.hour.compactMap { h in
                guard let t = h.time,
                      let date = DateFormatter.apiDateFormatter.date(from: t),
                      date > now else { return nil }
                return h
            } ?? []
            let tomorrow = resp.forecast.forecastday.dropFirst().first?.hour ?? []
            return today.count + tomorrow.count
        case 2: return resp.forecast.forecastday.count
        default: return 0
        }
    }

    func titleForHeader(in section: Int) -> String? {
        switch section {
        case 1: return "Hourly Forecast"
        case 2: return "Weekly Forecast"
        default: return nil
        }
    }

    func item(at indexPath: IndexPath) -> WeatherDisplayItem? {
        guard let resp = weatherResponse else { return nil }
        switch indexPath.section {
        case 0:
            let name = resp.location.name ?? "—"
            return .current(resp.current, locationName: name)
        case 1:
            let now = Date()
            let today = resp.forecast.forecastday.first?.hour.compactMap { h in
                guard let t = h.time,
                      let date = DateFormatter.apiDateFormatter.date(from: t),
                      date > now else { return nil }
                return h
            } ?? []
            let tomorrow = resp.forecast.forecastday.dropFirst().first?.hour ?? []
            let hours = today + tomorrow
            guard indexPath.row < hours.count else { return nil }
            return .hourly(hours[indexPath.row] as! HourlyWeather)
        case 2:
            let days = resp.forecast.forecastday
            guard indexPath.row < days.count else { return nil }
            return .daily(days[indexPath.row])
        default:
            return nil
        }
    }
}

