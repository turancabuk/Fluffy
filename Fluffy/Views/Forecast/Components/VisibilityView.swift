//
//  VisibilityView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct VisibilityView: View {
    
    var visibility: Int?     = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Image(systemName: "eye.fill")
                Text("visibility")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text("\(visibility ?? 0) m")
                .font(.system(size: 32, weight: .bold))
                .font(.title)
            Spacer()
        }
        .padding()
        .widgetStyleSubviews(width: UIScreen.main.bounds.width/2.15)
    }
}

#Preview {
    VisibilityView()
}
