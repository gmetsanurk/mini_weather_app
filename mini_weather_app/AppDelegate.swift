//
//  AppDelegate.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit
import CoreLocation

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private lazy var coordinator: AppCoordinator = {
        let win = UIWindow(frame: UIScreen.main.bounds)
        self.window = win
        return AppCoordinator(
            window: win,
            locationService: LocationService(),
            apiClient: WeatherAPIClient()
        )
    }()

    func application(
      _ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        Task { @MainActor in
            await coordinator.start()
        }
        return true
    }
}


