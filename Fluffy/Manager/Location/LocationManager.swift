//
//  LocationManager.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.10.2024.
//

import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared            = LocationManager()
    @Published var location      : CLLocation?
    @Published var isAuthorized  = false
    private let manager          = CLLocationManager()
    @Published var locationPermissionStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentCountryCode: String?
    @AppStorage("usesFahrenheit") var usesFahrenheit = false
    private let geoCoder = CLGeocoder()

    
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
        guard let location = locations.last else { return }
        
        determineCountry(location: location)
        
        DispatchQueue.main.async {
            self.location = location
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
    
    enum FahrenheitCountries: String {
        case usa     = "US"
        case bahamas = "BS"
        case caymans = "KY"
        case belise  = "BZ"
        
        static func usesFahrenheit(countryCode: String) -> Bool {
            return [usa.rawValue, bahamas.rawValue, caymans.rawValue, belise.rawValue].contains(countryCode)
        }
    }
    
    func formattedTemperature(temp: Double) -> String {
        if usesFahrenheit {
            let fahrenheitTemp = (temp * 9 / 5) + 32
            return "\(Int(fahrenheitTemp))°"
        }
        return "\(Int(temp))°"
    }
    
    func determineCountry(location: CLLocation) {
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self,
                  let countryCode = placemarks?.first?.isoCountryCode else {return}
            
            DispatchQueue.main.async {
                self.currentCountryCode = countryCode
                self.usesFahrenheit = FahrenheitCountries.usesFahrenheit(countryCode: countryCode)
            }
        }
    }
}

