//
//  MoonView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct MoonView: View {
    
    var moonrise      : Date?
    var moonset       : Date?
    var moonphase     : Double?  = 0
    var moonPhaseType : Daily.moonPhaseType?
    var timeFormatter : DateFormatter?
    
    var body: some View {
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
                        if let phaseType = moonPhaseType {
                            Text(phaseType.imageName)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                Spacer()
                VStack(alignment: .trailing) {
                    if let phaseType = moonPhaseType {
                        Image(phaseType.imageName)
                            .resizable()
                            .frame(width: 150, height: 150)
                            .scaledToFill()
                    }
                }
            }
            .foregroundStyle(.primary.opacity(0.6))
        }
        .widgetStyleSubviews()
        .padding(.horizontal, 8)
    }
}

#Preview {
    MoonView()
}
