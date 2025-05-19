//
//  AppCoordinator.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-19.
//

import UIKit
import CoreLocation

final class AppCoordinator {
    private let window: UIWindow
    private let locationService: LocationServiceProtocol
    private let apiClient: WeatherAPIClientProtocol
    
    init(window: UIWindow,
         locationService: LocationServiceProtocol,
         apiClient: WeatherAPIClientProtocol) {
        self.window = window
        self.locationService = locationService
        self.apiClient = apiClient
    }
    
    @MainActor
    func start() async {
        let loadingVC = LoadingViewController()
        window.rootViewController = loadingVC
        window.makeKeyAndVisible()

        do {
            let coord = try await locationService.requestLocation()
            showWeatherScreen(with: coord)
        } catch {
            showLocationError()
        }
    }
    
    private func showWeatherScreen(with coord: CLLocationCoordinate2D) {
        let presenter = WeatherPresenter(apiClient: apiClient, locationService: locationService)
        presenter.currentLat = coord.latitude
        presenter.currentLon = coord.longitude
        let weatherVC = WeatherViewController(presenter: presenter, apiClient: apiClient)
        presenter.view = weatherVC
        
        let nav = UINavigationController(rootViewController: weatherVC)
        window.rootViewController = nav
    }
    
    private func showLocationError() {
        guard let root = window.rootViewController else { return }
        let alert = UIAlertController(
            title: "Location Error",
            message: "Cannot get location",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            Task { await self?.start() }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        root.present(alert, animated: true)
    }
}
