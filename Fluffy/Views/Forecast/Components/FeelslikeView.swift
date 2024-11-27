//
//  FeelslikeView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct FeelslikeView: View {
    
    var feelsLike : Double?  = 0
    var morning   : Double?  = 0
    var evening   : Double?  = 0
    var night     : Double?  = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
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
        .widgetStyleSubviews(width: 190)
    }
}

#Preview {
    FeelslikeView()
}
