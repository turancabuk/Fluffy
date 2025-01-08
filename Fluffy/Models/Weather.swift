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

struct WeatherModel: Codable {
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

    var dailyWithTimezone: [Daily] {
        daily.map { daily in
            var updatedDaily = daily
            updatedDaily.timezoneOffset = self.timezoneOffset
            return updatedDaily
        }
    }
    
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
    let clouds: Int
    let visibility: Int?
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double?
    let weather: [Weather]
    let pop: Double?
    var timezoneOffset: Int = 0
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dt + timezoneOffset))
    }
    var sunriseDate: Date? {
        guard let sunrise = sunrise else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(sunrise + timezoneOffset))
    }
    
    var sunsetDate: Date? {
        guard let sunset = sunset else { return nil }
        return Date(timeIntervalSince1970: TimeInterval(sunset + timezoneOffset))
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

    var needsUmbrella: Bool {
        guard let weatherDesc = weather.first?.description.lowercased() else { return false }
        return weatherDesc.contains("rain") || weatherDesc.contains("shower")
    }
    
    var needsGloves: Bool {
        guard let weatherDesc = weather.first?.description.lowercased() else { return false }
        return weatherDesc.contains("snow")
    }
    
    var needsSunscreen: Bool {
        return temp >= 25 // 25°C ve üzeri için güneş kremi önerisi
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
    case the01D = "01d"
    case the01N = "01n"
    case the02D = "02d"
    case the02N = "02n"
    case the03D = "03d"
    case the03N = "03n"
    case the04D = "04d"
    case the04N = "04n"
    case the09D = "09d"
    case the09N = "09n"
    case the10D = "10d"
    case the10N = "10n"
    case the11D = "11d"
    case the11N = "11n"
    case the13D = "13d"
    case the13N = "13n"
    case the50D = "50d"
    case the50N = "50n"
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
    let summary: String
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
    var timezoneOffset: Int = 0
    var date: Date {
        Date(timeIntervalSince1970: TimeInterval(dt))
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case summary, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, uvi
    }
    
    enum moonPhaseType: String {
        case newMoon = "New Moon"
        case waxingCrescent = "Waxing Crescent"
        case firstQuarter = "First Quarter"
        case waxingGibbous = "Waxing Gibbous"
        case fullMoon = "Full Moon"
        case waningGibbous = "Waning Gibbous"
        case thirdQuarter = "Third Quarter"
        case waningCrescent = "Waning Crescent"
        
        var imageName: String {
            return self.rawValue
        }
    }
    
    var moonPhaseType: moonPhaseType {
        switch moonPhase {
        case 0.0, 1.0:
            return .newMoon
        case 0.0..<0.25:
            return .waxingCrescent
        case 0.25:
            return .waxingGibbous
        case 0.25..<0.5:
            return .firstQuarter
        case 0.5:
            return .fullMoon
        case 0.5..<0.75:
            return .waningGibbous
        case 0.75:
            return .thirdQuarter
        case 0.75..<1.0:
            return .waningCrescent
        default:
            return .newMoon
        }
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
