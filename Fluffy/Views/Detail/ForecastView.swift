//
//  ForecastView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

struct ForecastView: View {
    @ObservedObject var viewModel = ContentViewModel.shared
    var bottomSheetTranslationProrated: CGFloat = 1
    @State private var selection = 0

    var body: some View {
        ScrollView {
            VStack {
                SegmentedControlView(selection: $selection)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        if selection == 0 {
                            if let hourlyWeather = viewModel.hourlyWeather {
                                ForEach(hourlyWeather, id: \.dt) { forecast in
                                    ForecastCardView(forecastPeriod: .hourly, currentWeather: forecast)
                                }
                                .transition(.offset(x: -430))
                            }
                        } else {
                            if let dailyWeather = viewModel.dailyWeather {
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
            Image("Forecast Widgets")
        }
        .makeBlurView(radius: 25, opaque: true)
        .background(Color.bottomSheetBackground)
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
