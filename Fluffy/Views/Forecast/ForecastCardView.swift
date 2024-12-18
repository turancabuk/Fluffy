//
//  ForecastCardView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.10.2024.
//

import SwiftUI

struct ForecastCardView: View {
    
    @StateObject private var viewmodel = ContentViewModel.shared
    @StateObject private var locationManager = LocationManager.shared
    var forecastPeriod: ForecastPeriod
    var currentWeather: Current?
    var dailyWeather: Daily?

    // 24 saat formatı için formatter
    private let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"  // HH: 24 saat formatı (00-23)
        return formatter
    }()

    var isActive: Bool {
        if forecastPeriod == .hourly, let currentWeather = currentWeather {
            let isThisHour = Calendar.current.isDate(.now, equalTo: currentWeather.date, toGranularity: .hour)
            return isThisHour
        } else if let dailyWeather = dailyWeather {
            let isToday = Calendar.current.isDate(.now, equalTo: dailyWeather.date, toGranularity: .day)
            return isToday
        }
        return false
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(LinearGradient(colors: [.color, .color], startPoint: .topLeading, endPoint: .bottomLeading).opacity(0.4))
                .frame(width: 60, height: 146)
                .shadow(color: Color.black, radius: 2)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(.white.opacity(isActive ? 0.5 : 0.2))
                        .blendMode(.overlay)
                }
                .innerShadow(
                    shape: RoundedRectangle(cornerRadius: 30),
                    color: .white.opacity(isActive ? 0.5 : 0.2),
                    lineWidth: 1,
                    offsetX: 1,
                    offsetY: 1,
                    blur: 0,
                    blendMode: .overlay)

            VStack(spacing: 16) {
                if forecastPeriod == .hourly, let currentWeather = currentWeather {
                    Text(hourFormatter.string(from: currentWeather.date))
                        .font(.title3)
                    VStack(spacing: -4) {
                        Image("\(currentWeather.weather.first?.icon ?? "")")
                            .resizable()
                            .scaledToFill()
                        if currentWeather.pop ?? 0 > 0 {
                            Text(currentWeather.pop ?? 0, format: .percent)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.probabilityTextAsset)
                                .opacity(isActive ? 1 : 0.5)
                        }
                    }
                    .frame(height: 42)
                    let formattedTemp = viewmodel.locationManager.formattedTemperature(temp: currentWeather.temp)
                    Text(formattedTemp)
                        .font(.system(size: 18, weight: .bold))
                } else if let dailyWeather = dailyWeather {
                    Text(dailyWeather.date, format: .dateTime.weekday())
                        .font(.subheadline.weight(.semibold))
                    VStack(spacing: -4) {
                        Image("\(dailyWeather.weather.first?.icon ?? "defaultIcon")")
                            .resizable()
                            .scaledToFit()
                        if dailyWeather.pop ?? 0 > 0 {
                            Text(dailyWeather.pop ?? 0, format: .percent)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.probabilityTextAsset)
                                .opacity(isActive ? 1 : 0.5)
                        }
                    }
                    .frame(height: 42)
                    let formattedTemp = viewmodel.locationManager.formattedTemperature(temp: dailyWeather.temp.day)
                    Text(formattedTemp)
                        .font(.system(size: 18, weight: .bold))
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            .frame(width: 60, height: 146)
        }
    }
}

#Preview {
    ForecastCardView(forecastPeriod: ForecastPeriod.daily)
}
