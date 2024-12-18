//
//  Extensions.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

extension Color {
    static let background = LinearGradient(gradient: Gradient(colors: [Color("Background 1"), Color("Background 2")]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let bottomSheetBackground = LinearGradient(gradient: Gradient(colors: [Color("Background 1").opacity(0.26), Color("Background 2").opacity(0.26)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let navBarBackground = LinearGradient(gradient: Gradient(colors: [Color("Background 1").opacity(0.1), Color("Background 2").opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let tabBarBackground = LinearGradient(gradient: Gradient(colors: [Color("Background 1").opacity(0.26), Color("Background 2").opacity(0.26)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    static let weatherWidgetBackground = LinearGradient(gradient: Gradient(colors: [Color("Weather Widget Background 1"), Color("Weather Widget Background 2")]), startPoint: .leading, endPoint: .trailing)
    static let bottomSheetBorderMiddle = LinearGradient(gradient: Gradient(stops: [.init(color: .white, location: 0), .init(color: .clear, location: 0.2)]), startPoint: .top, endPoint: .bottom)
    static let bottomSheetBorderTop = LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .white, .white.opacity(0)]), startPoint: .leading, endPoint: .trailing)
    static let underLine = LinearGradient(gradient: Gradient(colors: [.white.opacity(0), .white, .white.opacity(0)]), startPoint: .leading, endPoint: .trailing)
    static let forecastCardBackground = Color("Forecast Card Background")
    static let probabilityText = Color("Probability Text")
}

extension View {
    func makeBlurView(radius: CGFloat = 0, opaque: Bool = false) -> some View {
        self
            .background(BlurView(radius: radius, opaque: opaque))
    }
}

extension View {
    func innerShadow<S: Shape, SS: ShapeStyle>(shape: S, color: SS, lineWidth: CGFloat = 1, offsetX: CGFloat = 0, offsetY: CGFloat = 0, blur: CGFloat = 4, blendMode: BlendMode = .normal, opacity: Double = 1) -> some View {
        return self
            .overlay(content: {
                shape
                    .stroke(color, lineWidth: lineWidth)
                    .blendMode(blendMode)
                    .offset(x: offsetX,y: offsetY)
                    .blur(radius: blur)
                    .mask(shape)
                    .opacity(opacity)
            })
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        foregroundColor: Color = .white,
        @ViewBuilder placeholder: () -> Content) -> some View {
        
        ZStack(alignment: alignment) {
            self
            placeholder()
                .foregroundStyle(foregroundColor)
                .opacity(shouldShow ? 1 : 0)
        }
    }
}
