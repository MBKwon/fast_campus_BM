//
//  LocationManager.swift
//  FastCampusRiders
//
//  Created by Moonbeom KWON on 2023/08/25.
//

import Combine
import CoreLocation
import Foundation

class LocationManager: NSObject {
    enum LocationError: Error {
        case permissionDenied
        case permissionRestricted
        case unknownError
    }
    
    private let locationManager = CLLocationManager()
    private static let defaultLocation = CLLocation(latitude: 37.54330366639085,
                                                    longitude: 127.04455548501139)
    
    let locationSubject = CurrentValueSubject<Result<CLLocation, LocationError>, Never>(.success(defaultLocation))
    
    override init() {
        super.init()
        self.locationManager.distanceFilter = 1_000
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.delegate = self
        self.checkAutorizationStatus()
    }
    
    func updateCurrentLocation() {
        self.locationManager.startUpdatingLocation()
    }
}
    
extension LocationManager {
    private func checkAutorizationStatus() {
        if #available(iOS 14.0, *) {
            switch self.locationManager.authorizationStatus {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted:
                self.locationSubject.send(.failure(.permissionRestricted))
            case .denied:
                self.locationSubject.send(.failure(.permissionDenied))
            case .authorizedAlways, .authorizedWhenInUse:
                do { }
            @unknown default:
                assertionFailure("@unknown authorizationStatus")
                self.locationSubject.send(.failure(.unknownError))
            }
        } else {
            // Fallback on earlier versions
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted:
                self.locationSubject.send(.failure(.permissionRestricted))
            case .denied:
                self.locationSubject.send(.failure(.permissionDenied))
            case .authorizedAlways, .authorizedWhenInUse:
                do { }
            @unknown default:
                assertionFailure("@unknown authorizationStatus")
                self.locationSubject.send(.failure(.unknownError))
            }
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkAutorizationStatus()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.checkAutorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        self.locationSubject.send(.success(currentLocation))
    }
}
