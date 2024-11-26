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

struct MoonView: View {
    
    var moonrise        : Date?
    var moonset         : Date?
    var moonphase       : Double?  = 0
    var moonPhaseType   : Daily.moonPhaseType?
    var timeFormatter   : DateFormatter?
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.thickMaterial)
            .frame(height: 180)
            .shadow(color: .white.opacity(0.25), radius: 2)
            .overlay {
                VStack(spacing: -6) {
                    HStack(spacing: 8) {
                        Image(systemName: "moon.stars.fill")
                        Text("moon phases")
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 8) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 12) {
                                Image(systemName: "moonrise.fill")
                                if let timeFormatter {
                                    Text("moonrise: \(moonrise.map {timeFormatter.string(from: $0)} ?? "HH:mm")")
                                }
                            }
                            Divider()
                                .background(Color.gray)
                            HStack(spacing: 12) {
                                Image(systemName: "moonset.fill")
                                if let timeFormatter {
                                    Text("moonset: \(moonset.map {timeFormatter.string(from: $0)} ?? "HH:mm")")
                                }
                            }
                            Divider()
                                .background(Color.gray)
                            HStack(spacing: 12) {
                                Image(systemName: "moon.road.lanes")
                                Text("phase:      \(String(format: "%.2f", moonphase ?? 0.0))")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 14)
                        Spacer()
                        VStack(alignment: .trailing) {
                            if let phaseType = moonPhaseType {
                                Image(phaseType.imageName)
                                    .resizable()
                                    .frame(width: 150, height: 150)
                                    .scaledToFill()
                            }
                        }
                        .padding(.bottom, 12)
                    }
                    .foregroundStyle(.gray)
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 8)
    }
}

struct WindView: View {
    
    @State var windDeg  : Int?     = 0
    var windSpeed       : Double?  = 0
    var windGust        : Double?  = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.thickMaterial)
            .frame(height: 180)
            .shadow(color: .white.opacity(0.25), radius: 2)
            .overlay {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Image(systemName: "wind.snow")
                        Text("wind")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("speed:   \(String(format: "%.2f", windSpeed ?? 0)) km/h")
                            Divider()
                                .background(Color.gray)
                            Text("gust:      \(String(format: "%.2f", windGust ?? 0)) km/h")
                            Divider()
                                .background(Color.gray)
                            Text("degree:  \(windDeg ?? 0)")
                        }
                        .foregroundStyle(.gray)
                        Spacer()
                        ZStack {
                            // Dış çember
                            Circle()
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                .frame(width: 120, height: 120)
                            
                            // Yön işaretleri (N, S, E, W)
                            VStack {
                                Text("N").font(.system(size: 12))
                                Spacer()
                                Text("S").font(.system(size: 12))
                            }
                            .foregroundStyle(.white)
                            .frame(height: 110)
                            
                            HStack {
                                Text("W").font(.system(size: 12))
                                Spacer()
                                Text("E").font(.system(size: 12))
                            }
                            .foregroundStyle(.white)
                            .frame(width: 110)
                            
                            // Küçük yön işaretleri
                            ForEach(0..<8) { i in
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 1, height: 8)
                                    .offset(y: -46)
                                    .rotationEffect(.degrees(Double(i) * 45))
                            }
                            
                            // Rüzgar yönü göstergesi (ok)
                            GeometryReader { geometry in
                                Path { path in
                                    let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/1.9)
                                    let length: CGFloat = 40  // Ok uzunluğu
                                    
                                    // Ok gövdesi
                                    path.move(to: center)
                                    path.addLine(to: CGPoint(x: center.x, y: center.y - length))
                                    
                                    // Ok başı
                                    let arrowWidth: CGFloat = 8
                                    path.move(to: CGPoint(x: center.x - arrowWidth, y: center.y - length + 12))
                                    path.addLine(to: CGPoint(x: center.x, y: center.y - length))
                                    path.addLine(to: CGPoint(x: center.x + arrowWidth, y: center.y - length + 12))
                                }
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            .white.opacity(0.9),
                                            .white.opacity(0.9),
                                            .white
                                        ]),
                                        startPoint: .center,
                                        endPoint: .top
                                    ),
                                    style: StrokeStyle(
                                        lineWidth: 4.5,
                                        lineCap: .round,
                                        lineJoin: .round
                                    )
                                )
                                .rotationEffect(.degrees(Double(windDeg ?? 0)), anchor: .center)
                                .animation(
                                    .spring(
                                        response: 5.8,
                                        dampingFraction: 0.8,
                                        blendDuration: 0
                                    ),
                                    value: windDeg
                                )
                            }
                            .frame(width: 100, height: 100)
                        }
                        .padding(.bottom)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical)
            }
            .onAppear {
                withAnimation {
                    windDeg = windDeg
                }
            }
            .onChange(of: windDeg) { newDeg in
                withAnimation {
                    windDeg = newDeg
                }
            }
            .padding(.horizontal, 8)
    }
}

struct PressureView: View {
    
    @State var animationProgress: Double = 0
    var pressure            : Int?     = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.thickMaterial)
            .frame(width: 190, height: 180)
            .shadow(color: .white.opacity(0.25), radius: 2)
            .overlay {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Image(systemName: "gauge.medium")
                        Text("pressure")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(Color.gray.opacity(0.3), lineWidth: 12)
                            .frame(width: 100, height: 100)
                        Circle()
                            .trim(from: 0, to: animationProgress)
                            .stroke(Color.white, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .frame(width: 100, height: 100)
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(duration: 7.0), value: animationProgress)
                        VStack {
                            Text("\(pressure ?? 0)")
                                .font(.system(size: 20, weight: .bold))
                            Text("hPa")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom)
                }
                .padding(.horizontal, 14)
                .padding(.vertical)
            }
            .onAppear {
                animationProgress = calculatePressureProgress(pressure ?? 0)
            }
            .onChange(of: pressure) { newPressure in
                animationProgress = calculatePressureProgress(newPressure ?? 0)
            }
    }
    
    private func calculatePressureProgress(_ pressure: Int) -> Double {
        let minPressure = 950.0
        let maxPressure = 1050.0
        
        let normalizedPressure = Double(pressure)
        let progress = (normalizedPressure - minPressure) / (maxPressure - minPressure)
        
        return min(max(progress, 0), 1)
    }
}

struct VisibilityView: View {
    
    var visibility          : Int?     = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.thickMaterial)
            .frame(width: 190, height: 180)
            .shadow(color: .white.opacity(0.25), radius: 2)
            .overlay {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Image(systemName: "eye.fill")
                        Text("visibility")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text("\(visibility ?? 0) m")
                        .font(.system(size: 32, weight: .bold))
                        .font(.title)
                    Spacer()
                }
                .padding()
            }
    }
}

struct SunriseView: View {
    
    var sunrise             : Date?
    var sunset              : Date?
    var timeFormatter   : DateFormatter?

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.thickMaterial)
            .frame(height: 180)
            .shadow(color: .white.opacity(0.25), radius: 2)
            .overlay {
                VStack(alignment: .leading, spacing: 24) {
                    HStack(spacing: 4) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "sunrise")
                                Text("sunrise")
                            }
                            .foregroundStyle(.gray)
                            if let timeFormatter {
                                Text("\(sunrise.map {timeFormatter.string(from: $0)} ?? "HH:mm")")
                                    .font(.title)
                                    .padding(.horizontal, 6)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        VStack(alignment: .trailing, spacing: 8) {
                            HStack {
                                Image(systemName: "sunset")
                                Text("sunset")
                            }
                            .foregroundStyle(.gray)
                            if let timeFormatter {
                                Text("\(sunset.map {timeFormatter.string(from: $0)} ?? "HH:mm")")
                                    .font(.title)
                                    .padding(.horizontal, 6)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical)
                Image("sunset")
                    .resizable()
                    .frame(height: 120)
                    .padding(.horizontal)
            }
            .padding(.horizontal, 8)
    }
}

struct HumidityView: View {
    
    var humidity            : Int?     = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.thickMaterial)
            .frame(width: 190, height: 180)
            .shadow(color: .white.opacity(0.25), radius: 2)
            .overlay {
                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Image(systemName: "humidity")
                        Text("humidity")
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 22))
                    .padding(.top, 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    Text("%\(humidity ?? 0)")
                        .font(.system(size: 60, weight: .medium))
                }
                .padding(.horizontal, 14)
                .padding(.vertical)
            }
    }
}

struct FeelslikeView: View {
    
    var feelsLike           : Double?  = 0
    var morning             : Double?  = 0
    var evening             : Double?  = 0
    var night               : Double?  = 0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.thickMaterial)
            .frame(width: 190, height: 180)
            .shadow(color: .white.opacity(0.25), radius: 2)
            .overlay {
                VStack(alignment: .leading) {
                    HStack(spacing: 2) {
                        Image(systemName: "thermometer.variable.and.figure")
                        Text("feelslike")
                            .font(.system(size: 22))
                        Spacer()
                        Text("\(Int(feelsLike?.rounded(.toNearestOrAwayFromZero) ?? 0))")
                            .font(.system(size: 28))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    HStack(spacing: 4) {
                        VStack(alignment: .leading) {
                            Text("morning: \(Int(morning?.rounded(.toNearestOrAwayFromZero) ?? 0))")
                                .foregroundStyle(.gray)
                            Divider()
                                .background(.gray)
                            Text("evening:  \(Int(evening?.rounded(.toNearestOrAwayFromZero) ?? 0))")
                                .foregroundStyle(.gray)
                            Divider()
                                .background(.gray)
                            Text("night:      \(Int(night?.rounded(.toNearestOrAwayFromZero) ?? 0))")
                                .foregroundStyle(.gray)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 14)
                .padding(.vertical)
            }
    }
}

struct SummaryView: View {
    
    var summary             : String?  = ""

    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(.forecastCardBackgroundAsset.opacity(0.4))
            .frame(height: 80)
            .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
            .overlay {
                Text(summary ?? "")
                    .padding(.horizontal, 14)
            }
            .padding(.horizontal, 6)
    }
}
