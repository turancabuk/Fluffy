//
//  ForecastView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

struct ForecastView: View {
    
    var currentWeather                  : Current? = nil
    var hourlyWeather                   : [Current]? = nil
    var dailyWeather                    : [Daily]? = nil
    @State private var selection        = 0
    var bottomSheetTranslationProrated  : CGFloat = 1

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                SegmentedControlView(selection: $selection)
                ScrollView(.horizontal) {
                    LazyHStack {
                        if selection == 0 {
                            if let hourlyWeather = hourlyWeather {
                                ForEach(hourlyWeather, id: \.dt) { forecast in
                                    ForecastCardView(forecastPeriod: .hourly, currentWeather: forecast)
                                        .padding(.horizontal, 2)
                                }
                                .transition(.offset(x: -430))
                            }
                        } else {
                            if let dailyWeather = dailyWeather {
                                ForEach(dailyWeather, id: \.dt) { forecast in
                                    ForecastCardView(forecastPeriod: .daily, dailyWeather: forecast)
                                }
                                .transition(.offset(x: 430))
                            }
                        }
                    }
                    .padding(.vertical, 20)
                }
                .padding(.horizontal, 20)
            }
            if let dailyWeather = dailyWeather?.first {
                let moonriseDate = Date(timeIntervalSince1970: TimeInterval(dailyWeather.moonrise + (hourlyWeather?.first?.timezoneOffset ?? 0)))
                let moonsetDate = Date(timeIntervalSince1970: TimeInterval(dailyWeather.moonset + (hourlyWeather?.first?.timezoneOffset ?? 0)))

                ForecastWidgetsView(
                    sunrise       : currentWeather?.sunriseDate,
                    sunset        : currentWeather?.sunsetDate,
                    feelsLike     : currentWeather?.feelsLike,
                    humidity      : currentWeather?.humidity,
                    summary       : dailyWeather.summary,
                    pressure      : currentWeather?.pressure,
                    windDeg       : currentWeather?.windDeg,
                    windSpeed     : currentWeather?.windSpeed,
                    windGust      : currentWeather?.windGust,
                    morning       : dailyWeather.feelsLike.morn,
                    evening       : dailyWeather.feelsLike.eve,
                    night         : dailyWeather.feelsLike.night,
                    visibility    : currentWeather?.visibility,
                    moonrise      : moonriseDate,
                    moonset       : moonsetDate,
                    moonphase     : dailyWeather.moonPhase,
                    moonPhaseType : dailyWeather.moonPhaseType
                )
            }
        }
        .makeBlurView(radius: 25, opaque: true)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 44))
        .innerShadow(
            shape: RoundedRectangle(cornerRadius: 44),
            color: Color.bottomSheetBorderMiddle,
            lineWidth: 1,
            offsetX: 0,
            offsetY: 1,
            blur: 0,
            blendMode: .overlay,
            opacity: 1 - bottomSheetTranslationProrated
        )
        .overlay {
            Divider()
                .blendMode(.overlay)
                .background(Color.bottomSheetBorderTop)
                .frame(maxHeight: .infinity, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 44))
        }
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.black.opacity(0.3))
                .frame(width: 48, height: 5)
                .frame(height: 20)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

#Preview {
    ForecastView()
}
