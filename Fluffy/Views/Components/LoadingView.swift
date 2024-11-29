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
                .ignoresSafeArea()
            ZStack {
                Image("pin")
                    .resizable()
                    .frame(width: 124, height: 124)
            }
        }
    }
}

#Preview {
    LoadingView()
}
