//
//  GeocodingModel.swift
//  Fluffy
//
//  Created by Turan Çabuk on 04.11.2024.
//

import SwiftUI

extension GeocodingModel {
    struct TurkishCity: Codable {
        let name: String
        let counties: [String]
    }
    
    static let turkishCities: [TurkishCity] = {
        guard let url = Bundle.main.url(forResource: "turkey-cities", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let cities = try? JSONDecoder().decode([TurkishCity].self, from: data) else {
            return []
        }
        return cities
    }()
    
    var stateForTurkishCity: String? {
        guard country == "TR" else { return state }
        // İlçe adını il ile eşleştir
        for city in Self.turkishCities {
            if city.counties.contains(where: { $0.lowercased() == name.lowercased() }) {
                return city.name.capitalized
            }
        }
        // Eğer ilçe bulunamadıysa, belki direkt il adıdır
        if let city = Self.turkishCities.first(where: { $0.name.lowercased() == name.lowercased() }) {
            return city.name.capitalized
        }
        return nil
    }
}

