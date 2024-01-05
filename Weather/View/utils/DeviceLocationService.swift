//
//  DeviceLocationService.swift
//  Weather
//
//  Created by Ilya Stoletov on 02.01.2024.
//

import Foundation
import Combine
import CoreLocation

class DeviceLocationService: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var cityNamePublisher = PassthroughSubject<String, Error>()
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
    
    private override init() {
        super.init()
    }
    
    static let shared = DeviceLocationService()
    
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.delegate = self
        return manager
    }()
    
    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        default:
            manager.stopUpdatingLocation()
            deniedLocationAccessPublisher.send()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(
            location,
            completionHandler: { placemarks, error in
                if error == nil && placemarks != nil {
                    self.cityNamePublisher.send(placemarks?.last?.name != nil ? placemarks!.last!.name! : "Error")
                }
            }
        )
        coordinatesPublisher.send(location.coordinate)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
    
    
}
