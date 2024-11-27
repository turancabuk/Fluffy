//
//  WindView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct WindView: View {
    
    @State var windDeg  : Int?     = 0
    var windSpeed       : Double?  = 0
    var windGust        : Double?  = 0
    
    var body: some View {
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
        .widgetStyleSubviews()
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

#Preview {
    WindView()
}
