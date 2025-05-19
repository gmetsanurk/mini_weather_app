//
//  LocationService.swift
//  mini_weather_app
//
//  Created by Georgy on 2025-05-16.
//

import UIKit
import CoreLocation

protocol LocationServiceProtocol {
    func requestLocation() async throws -> CLLocationCoordinate2D
}

final class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {
    private let manager: CLLocationManager
    private let moscowCoordinate = CLLocationCoordinate2D(
        latitude:  55.7558,
        longitude: 37.6176
    )
    
    private var continuation: CheckedContinuation<CLLocationCoordinate2D, Error>?
    
    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func requestLocation() async throws -> CLLocationCoordinate2D {
        return try await withCheckedThrowingContinuation { (cont: CheckedContinuation<CLLocationCoordinate2D, Error>) in
            self.continuation = cont
            
            switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            case .denied, .restricted:
                cont.resume(returning: moscowCoordinate)
                continuation = nil
            @unknown default:
                cont.resume(returning: moscowCoordinate)
                continuation = nil
            }
        }
    }
    
    // MARK: –– CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard continuation != nil else { return }
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            continuation?.resume(returning: moscowCoordinate)
            continuation = nil
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let cont = continuation else { return }
        if let coord = locations.first?.coordinate {
            cont.resume(returning: coord)
        } else {
            cont.resume(returning: moscowCoordinate)
        }
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(returning: moscowCoordinate)
        continuation = nil
    }
}
