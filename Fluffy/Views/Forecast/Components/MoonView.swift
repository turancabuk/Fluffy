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
        VStack {
            HStack(spacing: 8) {
                Image(systemName: "moon.stars.fill")
                Text("moon phases")
            }
            .padding(.horizontal, 18)
            .padding(.top, 14)
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 8) {
                VStack(alignment: .leading) {
                    HStack(spacing: 12) {
                        Image(systemName: "moonrise.fill")
                        if let timeFormatter {
                            Text("moonrise : \(moonrise.map {timeFormatter.string(from: $0)} ?? "HH:mm")")
                        }
                    }
                    Divider()
                        .background(Color.gray)
                    HStack(spacing: 12) {
                        Image(systemName: "moonset.fill")
                        if let timeFormatter {
                            Text("moonset  : \(moonset.map {timeFormatter.string(from: $0)} ?? "HH:mm")")
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
                            .frame(width: UIScreen.main.bounds.width/3.1, height: UIScreen.main.bounds.height/6)
                            .scaledToFill()
                    }
                }
            }
            .foregroundStyle(.primary.opacity(0.6))
        }
        .frame(height: UIScreen.main.bounds.height/4.5)
        .widgetStyleSubviews()
        .padding(.horizontal, 8)
    }
}

#Preview {
    MoonView()
}
