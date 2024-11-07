//
//  ForecastCardView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.10.2024.
//

import SwiftUI

struct ForecastCardView: View {
    @StateObject private var viewmodel = ContentViewModel.shared
    var forecastPeriod: ForecastPeriod
    var currentWeather: Current?
    var dailyWeather: Daily?

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
                .fill(.forecastCardBackgroundAsset.opacity(isActive ? 1 : 0.2))
                .frame(width: 60, height: 146)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
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
                    Text("\(currentWeather.date, format: .dateTime.hour()):00")
                        .font(.subheadline.weight(.semibold))
                    VStack(spacing: -4) {
                        Image("\(viewmodel.hourlyWeather?.first?.weather.first?.icon ?? "") small")
                        Text(currentWeather.pop ?? 0, format: .percent)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.probabilityTextAsset)
                            .opacity(isActive ? 1 : 0.5)
                    }
                    .frame(height: 42)
                    Text("\(Int(currentWeather.temp))°")
                        .font(.title2)
                } else if let dailyWeather = dailyWeather {
                    Text(dailyWeather.date, format: .dateTime.weekday())
                        .font(.subheadline.weight(.semibold))
                    VStack(spacing: -4) {
                        Image("\(dailyWeather.weather.first?.icon ?? "defaultIcon") small")
                        Text(dailyWeather.pop ?? 0, format: .percent)
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.probabilityTextAsset)
                            .opacity(isActive ? 1 : 0.5)
                    }
                    .frame(height: 42)
                    Text("\(Int(dailyWeather.temp.day))°")
                        .font(.title2)
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
