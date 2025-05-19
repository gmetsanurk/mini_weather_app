//
//  Untitled.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import CoreLocation

protocol LocationServiceProtocol {
    func requestLocation(completion: @escaping (CLLocationCoordinate2D) -> Void)
}

class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {
    private let manager = CLLocationManager()
    private var completion: ((CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        self.completion = completion
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            // Request location; will trigger delegate methods
            manager.requestLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        default:
            // Fallback to Moscow
            let moscow = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)
            completion(moscow)
        }
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else if status == .denied || status == .restricted {
            let moscow = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)
            completion?(moscow)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            completion?(location.coordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let moscow = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)
        completion?(moscow)
    }
}
