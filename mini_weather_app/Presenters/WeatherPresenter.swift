//
//  WeatherPresenter.swift
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

final class WeatherPresenter: WeatherPresenterProtocol {
    weak var view: WeatherViewProtocol?
    private let apiClient: WeatherAPIClientProtocol
    private let locationService: LocationServiceProtocol
    var weatherResponse: WeatherResponse?
    
    var currentLat: Double = 0
    var currentLon: Double = 0
    
    var sectionCount: Int {
        weatherResponse == nil ? 0 : 3
    }
    
    init(apiClient: WeatherAPIClientProtocol, locationService: LocationServiceProtocol) {
        self.apiClient = apiClient
        self.locationService = locationService
    }
    
    func viewDidLoad() {
        view?.showLoading()
        
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let coord = try await self.locationService.requestLocation()
                self.currentLat = coord.latitude
                self.currentLon = coord.longitude
                
                await MainActor.run { self.fetchWeather() }
            } catch {
                await MainActor.run { self.view?.showError(error.localizedDescription) }
            }
        }
    }
    
    func retry() {
        view?.showLoading()
        fetchWeather()
    }
    
    private func fetchWeather() {
        Task {
            do {
                let response = try await apiClient.fetchWeather(
                    lat: currentLat,
                    lon: currentLon,
                    days: 7
                )
                await MainActor.run {
                    view?.hideLoading()
                    view?.showWeather(response)
                }
            } catch {
                await MainActor.run {
                    view?.hideLoading()
                    view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return rowsForCurrentSection()
        case 1: return rowsForHourlySection()
        case 2: return rowsForDailySection()
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
        switch indexPath.section {
        case 0: return currentItem()
        case 1: return hourlyItem(at: indexPath.row)
        case 2: return dailyItem(at: indexPath.row)
        default: return nil
        }
    }
    
    // MARK: - Section: Current
    private func currentItem() -> WeatherDisplayItem? {
        guard let resp = weatherResponse else { return nil }
        let name = resp.location.name ?? "—"
        return .current(resp.current, locationName: name)
    }
    
    private func rowsForCurrentSection() -> Int {
        return weatherResponse == nil ? 0 : 1
    }
    
    // MARK: - Section: Hourly
    private func rowsForHourlySection() -> Int {
        guard let resp = weatherResponse else { return 0 }
        return combinedHourlyItems().count
    }
    
    private func hourlyItem(at row: Int) -> WeatherDisplayItem? {
        let items = combinedHourlyItems()
        guard row < items.count else { return nil }
        return .hourly(items[row])
    }
    
    private func combinedHourlyItems() -> [HourlyWeather] {
        guard let resp = weatherResponse else { return [] }
        let now = Date()
        let today = resp.forecast.forecastday.first?.hour.compactMap { h in
            guard let t = h.time,
                  let date = DateFormatter.apiDateFormatter.date(from: t),
                  date > now else { return nil }
            return h
        } ?? []
        let tomorrow = resp.forecast.forecastday.dropFirst().first?.hour ?? []
        return today as! [HourlyWeather] + tomorrow
    }
    
    // MARK: - Section: Daily
    private func rowsForDailySection() -> Int {
        return weatherResponse?.forecast.forecastday.count ?? 0
    }
    
    private func dailyItem(at row: Int) -> WeatherDisplayItem? {
        guard let day = weatherResponse?.forecast.forecastday[safe: row] else { return nil }
        return .daily(day)
    }
}

