//
//  NetworkManager.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.10.2024.
//

import SwiftUI

struct NetworkManager {
    
    func getCurrentWeather(latitude: Double, longitude: Double) async throws -> Current{
        guard let url = URL(string:
                                "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely,alerts&appid=068f33303987dd92002c812f8695a3bc") else {throw (NetworkError.badURL)}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weather   = try await JSONDecoder().decode(Welcome.self, from: data)
        return weather.current
    }
    
//    func getHourlyWeather(latitude: Double, longitude: Double) async throws -> [Current] {
//        guard let url = URL(string:
//                                "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&exclude=minutely,alerts&appid=068f33303987dd92002c812f8695a3bc") else {throw (NetworkError.badURL)}
//        
//        let (data, _) = try await URLSession.shared.data(from: url)
//        let weather   = try await JSONDecoder().decode(Welcome.self, from: data)
//        return weather.hourly
//    }
//    

    func getDailyWeather(latitude: Double, longitude: Double) async throws -> [Daily] {
        guard let url = URL(string:
                                "https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&exclude=minutely,alerts&appid=068f33303987dd92002c812f8695a3bc") else {throw (NetworkError.badURL)}
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let weather   = try await JSONDecoder().decode(Welcome.self, from: data)
        return weather.daily
    }
}
