//
//  ContentViewModel.swift
//  Fluffy
//
//  Created by Turan Çabuk on 28.10.2024.
//

import SwiftUI
import CoreLocation
import Combine

class ContentViewModel: ObservableObject {
    
    @ObservedObject var locationManager   : LocationManager
    @Published var cityLocation           : String = "Mevcut Konum"
    @Published var currentWeather         : Current? = nil
    @Published var hourlyWeather          : [Current]? = nil
    @Published var dailyWeather           : [Daily]? = nil
    private var cancellables              = Set<AnyCancellable>()
    private var hasFetcehedInitialWeather : Bool = false
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        locationManager.$location
            .compactMap { $0 } 
            .sink { [weak self] location in
                guard let self else { return }
                if !hasFetcehedInitialWeather {
                    Task {
                        await self.getCurrentWeather()
                        await self.getHourlyWeather()
                        await self.getDailyWeather()
                        self.fetchCityName(from: location)
                        self.hasFetcehedInitialWeather = true
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func getCurrentWeather() async {
        guard let location = locationManager.location else { return }
        
        do {
            let current = try await NetworkManager().getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.currentWeather = current
            print("Current setted")
        } catch {
            print("hata sebebi", error.localizedDescription)
        }
    }
    
    @MainActor
    func getHourlyWeather() async {
        guard let location = locationManager.location else { return }
        
        do {
            let hourly = try await Array(NetworkManager().getHourlyWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude).prefix(25))
            self.hourlyWeather = hourly
            print("Hourly setted")
        } catch {
            print("hata sebebi", error.localizedDescription)
        }
    }
    
    @MainActor
    func getDailyWeather() async {
        guard let location = locationManager.location else { return }
        
        do {
            let daily = try await NetworkManager().getDailyWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.dailyWeather = daily
            print("Daily setted")
        } catch {
            print("hata sebebi", error.localizedDescription)
        }
    }
    
    @MainActor
    private func fetchCityName(from location: CLLocation) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            guard let self = self else { return }
            if let placemark = placemarks?.first, let city = placemark.locality {
                DispatchQueue.main.async {
                    self.self .cityLocation = city
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
}
