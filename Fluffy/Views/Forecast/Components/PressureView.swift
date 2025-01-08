//
//  PressureView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct PressureView: View {
    
    @State var animationProgress : Double = 0
    var pressure                 : Int?     = 0
    
    var body: some View {
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
                        .foregroundStyle(.primary.opacity(0.6))
                }
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 14)
        .padding(.vertical)
        .widgetStyleSubviews(width: UIScreen.main.bounds.width/2.15)
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

#Preview {
    PressureView()
}
