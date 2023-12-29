//
//  LocationService.swift
//  AstonWeatherApp
//
//  Created by Гриша  on 28.12.2023.
//
import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    var currentCity: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func requestLocationAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    func getCurrentCity(completion: @escaping (String?, Error?) -> Void) {
        locationManager.requestLocation()
        self.completion = completion
    }
    // MARK: - CLLocationManagerDelegate Methods
    private var completion: ((String?, Error?) -> Void)?

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let placemark = placemarks?.first, let city = placemark.locality {
                    self.currentCity = city
                    self.completion?(city, nil)
                } else if let error = error {
                    self.completion?(nil, error)
                }
                self.completion = nil
            }
        }
        manager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completion?(nil, error)
        self.completion = nil
    }
}
