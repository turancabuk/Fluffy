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
    @Published var showLocationAlert      = false
    @Published var isLoading              : Bool = false
    private var cancellables              = Set<AnyCancellable>()
    private var hasFetchedWeather         = false
    @AppStorage("notificationsEnabled") var notificationsEnabled = false
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        locationManager.$location
            .compactMap { $0 }
            .filter { [weak self] _ in !self!.hasFetchedWeather }
            .sink { [weak self] location in
                guard let self else { return }
                
                Task {
                    self.showLoadingView()
                    await self.getWeather()
                    self.hasFetchedWeather = true
                    self.fetchCityName(from: location)
                    self.hideLoadingView()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func getWeather() async {
        guard let location = locationManager.location else { return }
        showLoadingView()
        do {
            let weather         = try await NetworkManager().getWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.currentWeather = weather.current
            self.hourlyWeather  = filterCurrentHours(hourlyWeather: Array(weather.hourly.prefix(25)))
            self.dailyWeather   = filterDailyHours(dailyWeather: weather.daily)
            hideLoadingView()
            print("***getWeather")
            
            // Bildirim aktifse güncelle
            if notificationsEnabled {
                scheduleWeatherNotification()
            }
        } catch {
            print("hata sebebi", error.localizedDescription)
            hideLoadingView()
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
    
    // Kullanıcının konum izin ayarları.
    func handleLocationButtonTapped() {
        if locationManager.checkLocationPermission() {
            // Konum izni varsa konumu güncelle
            locationManager.requestLocationPermissionOrUpdate()
            Task {
                await getWeather()
            }
        } else {
            // Konum izni yoksa alert göster
            showLocationAlert = true
        }
    }
    
    private func showLoadingView() { isLoading = true }
    private func hideLoadingView() { isLoading = false }
    
    // Kullanıcıya Push Notification göndermek için kullandığım methodlar.
    func toggleNotifications() {
        notificationsEnabled.toggle()
        if notificationsEnabled {
            NotificationManager.shared.requestNotificationPermission()
            scheduleWeatherNotification()
        } else {
            NotificationManager.shared.cancelAllNotifications()
        }
    }
    
    private func scheduleWeatherNotification() {
        guard let current = currentWeather,
              let daily = dailyWeather?.first else { return }
        
        NotificationManager.shared
            .scheduleDailyWeatherNotification(
                summary: daily.summary,
                temp: current.temp
            )
    }
    
    // Mevcut sıcaklık değerlerini kullanıcının bulunduğu konuma göre formatlama metodları.
    
    func formatTemperature(_ temperature: Double) -> String {
        return locationManager.formattedTemperature(temp: temperature)
    }
}
