//
//  ForecastWidgetsView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 20.11.2024.
//

import SwiftUI

struct ForecastWidgetsView: View {
    
    var animationProgress   : Double = 0
    var sunrise             : Date?
    var sunset              : Date?
    var feelsLike           : Double?  = 0
    var humidity            : Int?     = 0
    var summary             : String?  = ""
    var pressure            : Int?     = 0
    var windDeg             : Int?     = 0
    var windSpeed           : Double?  = 0
    var windGust            : Double?  = 0
    var morning             : Double?  = 0
    var evening             : Double?  = 0
    var night               : Double?  = 0
    var visibility          : Int?     = 0
    var moonrise            : Date?
    var moonset             : Date?
    var moonphase           : Double?  = 0
    var moonPhaseType       : Daily.moonPhaseType?
    
    let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                SummaryView(summary: summary)
            }
            HStack {
                FeelslikeView(feelsLike: feelsLike, morning: morning, evening: evening, night: night)
                HumidityView(humidity: humidity)
            }
            HStack {
                SunriseView(sunrise: sunrise, sunset: sunset, timeFormatter: timeFormatter)
            }
            HStack {
                PressureView(animationProgress: animationProgress, pressure: pressure)
                VisibilityView(visibility: visibility)
            }
            HStack {
                WindView(windDeg: windDeg, windSpeed: windSpeed, windGust: windGust)
            }
            HStack {
                MoonView(moonrise: moonrise, moonset: moonset, moonphase: moonphase, moonPhaseType: moonPhaseType, timeFormatter: timeFormatter)
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    ForecastWidgetsView()
}

