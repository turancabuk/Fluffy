//
//  NavigationBarViewModel.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.11.2024.
//

import SwiftUI

class NavigationBarViewModel: ObservableObject {
    @Published var searchText       = ""
    @Published var weather          : WeatherModel?
    @Published var currentWeather   : Current? = nil
    @Published var hourlyWeather    : [Current]? = nil
    @Published var dailyWeather     : [Daily]? = nil
    @Published var isLoading        = false
    @Published var errorMessage     : String?
    private let networkManager      = NetworkManager()
    
    func searchCity() async {
        guard !searchText.isEmpty else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }
        
        do {
            // Önce şehir koordinatlarını al
            if let coordinates = try await networkManager.getCoordinates(for: searchText) {
                // Koordinatları kullanarak hava durumunu al
                let weather = try await networkManager.getWeather(
                    latitude: coordinates.lat,
                    longitude: coordinates.lon
                )
                
                DispatchQueue.main.async {
                    self.weather        = weather
                    self.currentWeather = weather.current
                    self.hourlyWeather  = weather.hourly
                    self.dailyWeather   = weather.daily
                    self.isLoading      = false
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Şehir bulunamadı"
                    self.isLoading = false
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
