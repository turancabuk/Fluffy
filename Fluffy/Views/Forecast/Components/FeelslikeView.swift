//
//  FeelslikeView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct FeelslikeView: View {
    
    @StateObject private var locationManager = LocationManager.shared
    var feelsLike : Double?  = 0
    var morning   : Double?  = 0
    var evening   : Double?  = 0
    var night     : Double?  = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("feelslike")
                    .font(.system(size: 20))
                Spacer()
                Text(locationManager.formattedTemperature(temp: feelsLike ?? 0))
                    .font(.system(size: 38))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack(spacing: 4) {
                VStack(alignment: .leading) {
                    Text("morning : \(locationManager.formattedTemperature(temp: morning ?? 0))")
                        .foregroundStyle(.primary.opacity(0.6))
                    Divider()
                        .background(.gray)
                    Text("evening  : \(locationManager.formattedTemperature(temp: evening ?? 0))")
                        .foregroundStyle(.primary.opacity(0.6))
                    Divider()
                        .background(.gray)
                    Text("night       : \(locationManager.formattedTemperature(temp: night ?? 0))")
                        .foregroundStyle(.primary.opacity(0.6))
                }
            }
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical)
        .widgetStyleSubviews(width: 190)
    }
}

#Preview {
    FeelslikeView()
}
