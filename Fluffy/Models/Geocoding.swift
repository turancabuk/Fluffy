//
//  Geocoding.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.11.2024.
//

import Foundation

struct GeocodingModel: Codable, Identifiable {
    let id = UUID()
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    var state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case lat
        case lon
        case country
        case state
    }
    
    var fullLocationName: String {
        if let state = state {
            return "\(name)/\(state)/\(country)"
        }
        return "\(name)/\(country)"
    }
}
 
