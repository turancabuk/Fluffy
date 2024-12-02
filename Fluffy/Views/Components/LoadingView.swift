//
//  LoadingView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 29.11.2024.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        Image("pin")
            .resizable()
            .frame(width: 132, height: 162)
            .allowsHitTesting(true)
    }
}

#Preview {
    LoadingView()
}
