//
//  AppDelegate.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit
import CoreLocation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private let locationService = LocationService()
    private var didSetupRoot = false

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        locationService.requestLocation { [weak self] coord in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.setupRootView(with: coord)
            }
        }
        return true
    }

    private func setupRootView(with coord: CLLocationCoordinate2D) {
        guard !didSetupRoot else { return }
        didSetupRoot = true

        window = UIWindow(frame: UIScreen.main.bounds)
        let apiClient = WeatherAPIClient()
        let presenter = WeatherPresenter(apiClient: apiClient, locationService: locationService)
        presenter.currentLat = coord.latitude
        presenter.currentLon = coord.longitude

        let rootVC = WeatherViewController(presenter: presenter)
        presenter.view = rootVC

        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
    }
}


