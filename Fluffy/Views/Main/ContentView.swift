//
//  ContentView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top    = 0.83  // 702/844
    case middle = 0.385 // 325/844
}

struct ContentView: View {
    
    @StateObject private var viewmodel  = ContentViewModel.shared
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
    @State var bottomSheetPosition      : BottomSheetPosition = .middle
    @State var bottomSheetTranslation   : CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged               : Bool = false
    var bottomSheetTranslationProrated: CGFloat {
        let translation = (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) /
                         (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
        return min(max(translation, 0), 1)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if viewmodel.isLoading {
                    LoadingView()
                }else{
                    GeometryReader { geometry in
                        let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                        let imageOffset = screenHeight + 36
                        ZStack {
                            Image("House")
                                .resizable()
                                .frame(width: 500)
                                .scaledToFit()
                                .ignoresSafeArea()
                                .offset(y: -bottomSheetTranslationProrated * imageOffset)
                                .padding(.leading, -58)
                            
                            // MARK: Current Weather
                            VStack(alignment: .center, spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                                ThemeSwitcher()
                                    .padding(EdgeInsets(top: -40, leading: 270, bottom: 0, trailing: 0))
                                    .offset(y: -bottomSheetTranslationProrated * imageOffset)
                                Text("\(viewmodel.cityLocation)")
                                    .font(.largeTitle)
                                    .foregroundStyle(hasDragged ? .primary : Color.black.opacity(0.6))
                                VStack {
                                    Text(attributedString)
                                        .multilineTextAlignment(.center)
                                        .frame(maxWidth: .infinity)

                                    if let daily = viewmodel.dailyWeather?.first {
                                        let dailyMax  = Int(daily.temp.max.rounded(.toNearestOrAwayFromZero))
                                        let formattedDailyMax = viewmodel.locationManager.formattedTemperature(temp: Double(dailyMax))
                                        let dailyMin  = Int(daily.temp.min.rounded(.toNearestOrAwayFromZero))
                                        
                                        HStack(spacing: 2) {
                                            HStack {
                                                Image(systemName: "chevron.up.2")
                                                Text("\(formattedDailyMax)")
                                            }
                                            Text(" | ")
                                                .font(.system(size: 32).weight(.semibold))
                                            HStack {
                                                Image(systemName: "chevron.down.2")
                                                Text("\(viewmodel.locationManager.formattedTemperature(temp: Double(dailyMin)))")
                                            }
                                        }
                                        .font(.title3.weight(.semibold))
                                        .opacity(1 - bottomSheetTranslationProrated)
                                        .foregroundStyle(.black.opacity(0.6))
                                    }
                                }
                                Spacer()
                            }
                            .padding(.top, 51)
                            .padding(.leading, hasDragged ? -68 : 0)
                            .offset(y: -bottomSheetTranslationProrated * 46)
                        }

                        
                        BottomSheetView(position: $bottomSheetPosition) {
                            // ...
                        } content: {
                            ForecastView(currentWeather: viewmodel.currentWeather, hourlyWeather: viewmodel.hourlyWeather, dailyWeather: viewmodel.dailyWeather)
                        }
                        .onBottomSheetDrag { translation in
                            bottomSheetTranslation = translation / screenHeight
                        }
                        .onChange(of: bottomSheetPosition) { newPosition in
                            withAnimation(.easeInOut(duration: 0.15)) {
                                hasDragged = newPosition == .top
                            }
                        }
                        TabBarView(navButtonTapped: {
                            viewmodel.handleLocationButtonTapped()
                        })
                        .offset(y: bottomSheetTranslationProrated * 115)
                    }
                }
            }
        }
        .alert("Location Permission Required", isPresented: $viewmodel.showLocationAlert) {
            Button("Go to Settings") {
                 if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("We need location permission to display weather information.")
        }
        .task {
            await viewmodel.getWeather()
        }
        .navigationBarHidden(true)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
    private var attributedString: AttributedString {
        guard let currentWeather = viewmodel.currentWeather else { return AttributedString() }
        let roundedTemp = Int(currentWeather.temp.rounded(.toNearestOrAwayFromZero))
        let weatherDescription = currentWeather.weather.first?.description
        
        var formattedTemp = viewmodel.locationManager.formattedTemperature(temp: Double(roundedTemp))
        if viewmodel.locationManager.usesFahrenheit {
            formattedTemp = "\(formattedTemp)F"
        }else{
            formattedTemp = "\(formattedTemp)"
        }
        
        let formattedTemp1 = viewmodel.locationManager.usesFahrenheit ? "\(roundedTemp)F" : "\(roundedTemp)"
        
        var string = AttributedString("\(formattedTemp)" + (hasDragged ? " | " : "\n ") + "\(weatherDescription ?? "")")

        if let temp = string.range(of: formattedTemp) {
            string[temp].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))), weight: hasDragged ? .semibold : .thin)
            string[temp].foregroundColor = hasDragged ? .secondary : .black
         }
         
         if let pipe = string.range(of: " | ") {
             string[pipe].font = .title3.weight(.semibold)
             string[pipe].foregroundColor = .secondary.opacity(bottomSheetTranslationProrated)
         }
         
        if let weather = string.range(of: "\(weatherDescription ?? "")") {
             string[weather].font = .title3.weight(.semibold)
            string[weather].foregroundColor = hasDragged ? .secondary : Color.black.opacity(0.6)
         }
         return string
     }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "EN"))
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .environment(\.locale, Locale(identifier: "TR"))
}
