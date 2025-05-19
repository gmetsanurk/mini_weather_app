//
//  Untitled.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import Foundation

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

    private var currentLat: Double = 0
    private var currentLon: Double = 0

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
