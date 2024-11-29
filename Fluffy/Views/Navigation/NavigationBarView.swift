//
//  NavigationBarView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 28.10.2024.
//

import SwiftUI

struct NavigationBarView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel = NavigationBarViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar ve Search Bar kısmı
            VStack {
                // Back button ve başlık
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                                .font(.system(size: 23).weight(.medium))
                            Text("Weather")
                                .foregroundStyle(.white)
                                .font(.title)
                        }
                        .frame(height: 44)
                    }
                    Spacer()
                }
                .frame(height: 52)
                
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search a city or airport", text: $viewModel.searchText)
                        .onSubmit {
                            Task {
                                await viewModel.searchCity()
                            }
                        }
                    
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal, 6)
                .padding(.vertical, 7)
                .frame(height: 36, alignment: .leading)
                .background(Color.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 10))
                .innerShadow(shape: RoundedRectangle(cornerRadius: 10), color: .black, lineWidth: 1, offsetX: 0, offsetY: 2, blur: 2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 49)
            .makeBlurView(radius: 20, opaque: true)
            .background(Color.navBarBackground)
            
            // Content Area - Scrollable
            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 20)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundStyle(.red)
                        .padding(.top, 20)
                } else if let weather = viewModel.currentWeather {
                    
                    if let dailyWeather = viewModel.dailyWeather?.first {
                        let moonriseDate = Date(timeIntervalSince1970: TimeInterval(dailyWeather.moonrise + (viewModel.hourlyWeather?.first?.timezoneOffset ?? 0)))
                        let moonsetDate = Date(timeIntervalSince1970: TimeInterval(dailyWeather.moonset + (viewModel.hourlyWeather?.first?.timezoneOffset ?? 0)))
                        
                        ForecastWidgetsView(
                            sunrise         : weather.sunriseDate,
                            sunset          : weather.sunsetDate,
                            feelsLike       : weather.feelsLike,
                            humidity        : weather.humidity,
                            summary         : dailyWeather.summary,
                            pressure        : weather.pressure,
                            windDeg         : dailyWeather.windDeg,
                            windSpeed       : dailyWeather.windSpeed,
                            windGust        : dailyWeather.windGust,
                            morning         : dailyWeather.feelsLike.morn,
                            evening         : dailyWeather.feelsLike.eve,
                            night           : dailyWeather.feelsLike.night,
                            visibility      : weather.visibility,
                            moonrise        : moonriseDate,
                            moonset         : moonsetDate,
                            moonphase       : dailyWeather.moonPhase,
                            moonPhaseType   : dailyWeather.moonPhaseType)
                        .padding(.vertical, 20)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    NavigationBarView()
}
