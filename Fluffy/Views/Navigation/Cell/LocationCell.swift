//
//  LocationCell.swift
//  Fluffy
//
//  Created by Turan Çabuk on 4.12.2024.
//

import SwiftUI

struct LocationCell: View {
    let location: GeocodingModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.title3)
                .foregroundStyle(.primary)
            
            Text(location.fullLocationName)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.bottomSheetBackground)
        .cornerRadius(10)
    }
}
