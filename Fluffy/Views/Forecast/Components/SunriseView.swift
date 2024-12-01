//
//  SunriseView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct SunriseView: View {
    
    var sunrise       : Date?
    var sunset        : Date?
    var timeFormatter : DateFormatter?
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 24) {
                HStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "sunrise")
                            Text("sunrise")
                        }
                        .foregroundStyle(.primary.opacity(0.6))
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
                        .foregroundStyle(.primary.opacity(0.6))
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
                .frame(height: 140)
                .padding()
        }
        .widgetStyleSubviews()
        .padding(.horizontal, 8)
    }
}

#Preview {
    SunriseView()
}
