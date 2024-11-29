//
//  LocationManager.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.10.2024.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    @Published var location      : CLLocation?
    @Published var isAuthorized  = false
    private let manager          = CLLocationManager()
    @Published var locationPermissionStatus: CLAuthorizationStatus = .notDetermined

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        if let currentLocation = location, currentLocation.distance(from: newLocation) < 100 {
            return
        }
        DispatchQueue.main.async {
            self.location = newLocation
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            isAuthorized = true
            manager.startUpdatingLocation()
        }else{
            isAuthorized = false
        }
    }
    
    func checkLocationPermission() -> Bool {
        let status = manager.authorizationStatus
        locationPermissionStatus = status
        return status == .authorizedWhenInUse || status == .authorizedAlways
    }
    
    func requestLocationPermissionOrUpdate() {
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            requestLocation()
        case .restricted, .denied:
            // Ayarlara yönlendirme için URL'i kontrol et
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        case .authorizedWhenInUse, .authorizedAlways:
            // Konumu güncelle
            manager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
}
