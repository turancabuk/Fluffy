//
//  SearchViewModel.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.11.2024.
//

import SwiftUI

class SearchViewModel: ObservableObject {
    @Published var searchText       = ""
    @Published var searchResults    : [GeocodingModel] = []
    @Published var selectedLocation : GeocodingModel?
    @Published var currentWeather   : Current?
    @Published var hourlyWeather    : [Current]?
    @Published var dailyWeather     : [Daily]?
    @Published var isLoading        = false
    private let networkManager      = NetworkManager()
    
    func searchLocations() async {
        guard !searchText.isEmpty else { return }
        isLoading = true
        
        do {
            let locations = try await networkManager.getLocations(for: searchText)
            DispatchQueue.main.async {
                self.searchResults = locations
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
                self.searchResults = []
            }
        }
    }
    
    func selectLocation(_ location: GeocodingModel) async {
        isLoading = true
        do {
            let weather = try await networkManager.getWeather(
                latitude: location.lat,
                longitude: location.lon
            )
            DispatchQueue.main.async {
                self.currentWeather     = weather.current
                self.hourlyWeather      = weather.hourly
                self.dailyWeather       = weather.daily
                self.selectedLocation   = location
                self.isLoading          = false
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
    
    func clearSelection() {
        selectedLocation = nil
        currentWeather = nil
        hourlyWeather = nil
        dailyWeather = nil
    }
}
