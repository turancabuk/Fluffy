//
//  LocationCell.swift
//  Fluffy
//
//  Created by Turan Çabuk on 4.12.2024.
//

import SwiftUI

struct LocationCell: View {
    @Environment(\.colorScheme) var colorScheme
    let location: GeocodingModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.title3)
                .foregroundStyle(colorScheme == .light ? .white : .black)
            
            Text(location.fullLocationName)
                .font(.caption)
                .foregroundStyle(colorScheme == .light ? .white : .black)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(colorScheme == .light ? .black.opacity(0.8) : .white.opacity(0.8))
                .shadow(color: Color.color1, radius: 4)
        )
    }
}
