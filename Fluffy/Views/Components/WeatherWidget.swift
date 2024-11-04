//
//  WeatherWidget.swift
//  Fluffy
//
//  Created by Turan Çabuk on 28.10.2024.
//

//import SwiftUI
//
//struct WeatherWidget: View {
//    
//    var forecast: Forecast
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Trapezoid()
//                .fill(Color.weatherWidgetBackground)
//                .frame(width: 342, height: 174)
//            HStack(alignment: .bottom) {
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("\(forecast.temperature)°")
//                        .font(.system(size: 64))
//                    VStack(alignment: .leading) {
//                        Text("H: \(forecast.low)° / L:\(forecast.high)°")
//                            .font(.footnote)
//                            .foregroundStyle(.secondary)
//                        Text(forecast.location)
//                            .font(.body)
//                            .lineLimit(1)
//                    }
//                }
//                Spacer()
//                VStack(alignment: .trailing, spacing: 0) {
//                    Image("\(forecast.icon) large")
//                        .padding(.trailing, 4)
//                    Text(forecast.weather.rawValue)
//                        .font(.footnote)
//                        .padding(.trailing, 24)
//                }
//            }
//            .foregroundStyle(.white)
//            .padding(.bottom, 20)
//            .padding(.leading, 20)
//        }
//        .frame(width: 342, height: 184, alignment: .bottom)
//    }
//}
//
//#Preview {
//    WeatherWidget(forecast: Forecast.cities[0])
//        .preferredColorScheme(.dark)
//}
