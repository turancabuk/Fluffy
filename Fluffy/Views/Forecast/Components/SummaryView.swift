//
//  SummaryView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct SummaryView: View {
    
    var summary : String?  = ""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(LinearGradient(colors: [.color2, .color3], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(height: 80)
            .shadow(color: .black.opacity(0.25), radius: 10, x: 5, y: 4)
            .overlay {
                Text(summary ?? "")
                    .foregroundStyle(.black)
                    .padding(.horizontal, 14)
            }
            .padding(.horizontal, 6)
    }
}

#Preview {
    SummaryView()
}
