//
//  HumidityView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct HumidityView: View {
    
    var humidity: Int?     = 0
    
    var body: some View {
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
        .widgetStyleSubviews(width: 190)
    }
}

#Preview {
    HumidityView()
}
