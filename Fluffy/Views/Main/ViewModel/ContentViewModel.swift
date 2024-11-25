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
    
    static let shared = ContentViewModel(locationManager: LocationManager.shared)
    @ObservedObject var locationManager   : LocationManager
    @Published var cityLocation           : String = "Mevcut Konum"
    @Published var currentWeather         : Current? = nil
    @Published var hourlyWeather          : [Current]? = nil
    @Published var dailyWeather           : [Daily]? = nil
    private var cancellables              = Set<AnyCancellable>()
    private var hasFetchedWeather         = false
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        locationManager.$location
            .compactMap { $0 }
            .filter { [weak self] _ in !self!.hasFetchedWeather }
            .sink { [weak self] location in
                guard let self else { return }
                
                Task {
                    await self.getWeather()
                    self.hasFetchedWeather = true
                    self.fetchCityName(from: location)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func getWeather() async {
        guard let location = locationManager.location else { return }
        
        do {
            let weather = try await NetworkManager().getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.currentWeather = weather.current
            self.hourlyWeather  = filterCurrentHours(hourlyWeather: Array(weather.hourly.prefix(25)))
            self.dailyWeather   = filterDailyHours(dailyWeather: weather.daily)
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
                    self.cityLocation = city
                }
            } else {
                print(error?.localizedDescription ?? "No location found")
            }
        }
    }
    
    private func filterCurrentHours(hourlyWeather: [Current]) -> [Current] {
        let currentDate = Date()
        let currentTimeStamp = Int(currentDate.timeIntervalSince1970)
        
        return hourlyWeather.filter { hourly in
            return hourly.dt >= currentTimeStamp
        }
    }
    
    private func filterDailyHours(dailyWeather: [Daily]) -> [Daily] {
        let currentDate = Date()
        let currentTimeStamp = Int(currentDate.timeIntervalSince1970)
        
        return dailyWeather.filter { daily in
            return daily.dt >= currentTimeStamp
        }
    }
}
