//
//  SegmentedControlView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 24.10.2024.
//

import SwiftUI

struct SegmentedControlView: View {
    
    @Binding var selection : Int
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        selection = 0
                    }
                } label: {
                    Text("Hourly Forecast")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundStyle(selection == 0 ? .primary : .secondary)
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        selection = 1
                    }
                } label: {
                    Text("Weekly Forecast")
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                .foregroundStyle(selection == 1 ? .primary : .secondary)
            }
            .font(.subheadline.weight(.semibold))
            Divider()
                .background(.white.opacity(0.5))
                .blendMode(.overlay)
                .shadow(color: .black.opacity(0.2), radius: 0, x: 0, y: 1)
                .blendMode(.overlay)
                .overlay {
                    HStack {
                        Divider()
                            .frame(width: UIScreen.main.bounds.width / 2, height: 3)
                            .background(Color.underLine)
                            .blendMode(.overlay)
                    }
                    .frame(maxWidth: .infinity, alignment: selection == 0 ? .leading : .trailing)
                }
        }
        .padding(.top, 25)
    }
}

#Preview {
    SegmentedControlView(selection: .constant(0))
}
