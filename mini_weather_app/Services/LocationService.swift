//
//  LocationService.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import CoreLocation

protocol LocationServiceProtocol {
    func requestLocation(completion: @escaping (CLLocationCoordinate2D) -> Void)
}

class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {
    private let manager: CLLocationManager
    private var completion: ((CLLocationCoordinate2D) -> Void)?
    
    private let moscowCoordinate = CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6176)

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocation(completion: @escaping (CLLocationCoordinate2D) -> Void) {
        self.completion = { coord in
            DispatchQueue.main.async { completion(coord) }
            self.completion = nil
        }
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        default:
            // fallback
            self.completion?(moscowCoordinate)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            completion?(moscowCoordinate)
            completion = nil
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coord = locations.first?.coordinate {
            completion?(coord)
        } else {
            completion?(moscowCoordinate)
        }
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(moscowCoordinate)
        completion = nil
    }
}
