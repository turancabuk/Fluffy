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
    
    @ObservedObject var locationManager : LocationManager
    @Published var currentWeather       : Current? = nil
    @Published var dailyWeather         : [Daily]? = nil
    private var cancellables            = Set<AnyCancellable>()
    
    init(locationManager: LocationManager) {
        self.locationManager = locationManager
        locationManager.$location
            .compactMap { $0 } 
            .sink { [weak self] location in
                Task {
                    await self?.getCurrentWeather()
                    await self?.getDailyWeather()
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func getCurrentWeather() async {
        guard let location = locationManager.location else {
            print("Hata burada")
            return }
        
        do {
            let current = try await NetworkManager().getCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.currentWeather = current
        } catch {
            print("hata sebebi", error.localizedDescription)
        }
    }
    
    @MainActor
    func getDailyWeather() async {
        guard let location = locationManager.location else {
            print("Hata burada")
            return }
        
        do {
            let daily = try await NetworkManager().getDailyWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self.dailyWeather = daily
        } catch {
            print("hata sebebi", error.localizedDescription)
        }
    }
}
