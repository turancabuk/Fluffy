//
//  LoadingView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.11.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            ProgressView()
                .tint(.color1)
                .scaleEffect(2)
                .foregroundColor(.red)
        }
    }
}

#Preview {
    LoadingView()
}
