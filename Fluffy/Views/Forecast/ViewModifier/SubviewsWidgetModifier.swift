//
//  SubviewsWidgetModifier.swift
//  Fluffy
//
//  Created by Turan Çabuk on 27.11.2024.
//

import SwiftUI

struct SubviewsWidgetModifier: ViewModifier {
    
    let width: CGFloat?
    
    init(width: CGFloat? = 190) {
        self.width = width
    }
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(.thickMaterial)
            )
            .frame(width: width)
            .shadow(color: Color.white.opacity(0.25), radius: 2)
    }
}

extension View {
    func widgetStyleSubviews(width: CGFloat? = nil) -> some View {
        self.modifier(SubviewsWidgetModifier(width: width))
    }
}
