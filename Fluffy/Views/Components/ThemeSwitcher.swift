//
//  ThemeSwitcher.swift
//  Fluffy
//
//  Created by Turan Çabuk on 13.12.2024.
//

import SwiftUI

struct ThemeSwitcher: View {
    
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Button {
            isDarkMode.toggle()
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        } label: {
            ZStack {
                Capsule()
                    .frame(width: 82, height: 34)
                    .overlay {
                        Image(isDarkMode ? "moony" : "sunny")
                            .resizable()
                    }
                Capsule()
                    .frame(width: 32, height: 32)
                    .offset( y: 2)
                    .overlay {
                        Image(isDarkMode ? "moonyButton" : "sunnyButton")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .offset(x: -2, y: 2)
                    }
                    .frame(maxWidth: .infinity, alignment: isDarkMode ? .leading : .trailing)
            }
        }
        .frame(width: 84, height: 36)
        .onAppear {
            isDarkMode = colorScheme == .dark
        }
    }
}

#Preview {
    ThemeSwitcher()
}
