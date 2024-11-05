//
//  Weather.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.10.2024.

import Foundation

enum ForecastPeriod {
    case hourly
    case daily
}

struct Welcome: Codable {
    let lat, lon: Double
    let timezone: String
    let timezoneOffset: Int
    let current: Current
    let hourly: [Current]
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }

    // Segmented control yardımıyla saatlik veya günlük veriyi dönecek bir fonksiyon
    func forecastData(for period: ForecastPeriod) -> [any Identifiable] {
        switch period {
        case .hourly:
            return hourly
        case .daily:
            return daily
        }
    }
}

// MARK: - Current
struct Current: Codable, Identifiable {
    var id: UUID = UUID()
    let dt: Int
    let sunrise, sunset: Int?
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let pop: Double?
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dt))
    }

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, pop
    }
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}


enum Icon: String, Codable {
    case the01D = "Moon"
    case the01N = "Cloud"
    case the02N = "Moon cloud mid rain"
    case the03D = "Sun cloud angled rain"
    case the03N = "Sun"
    case the04D = "Tornado"
    case the10D = "Moon cloud fast wind"
}


enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Daily
struct Daily: Codable, Identifiable {
    var id: UUID = UUID()
    let dt, sunrise, sunset, moonrise: Int
    let moonset: Int
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let clouds: Int
    let pop: Double?
    let uvi: Double
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dt))
    }
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi
    }
}

// MARK: - FeelsLike
struct FeelsLike: Codable {
    let day, night, eve, morn: Double
}

// MARK: - Temp
struct Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double
}
