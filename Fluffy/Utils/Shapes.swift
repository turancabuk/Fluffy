//
//  Shapes.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

struct Arc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX - 1, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX + 1, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX + 1, y: rect.maxY + 1))
        path.addLine(to: CGPoint(x: rect.minX - 1, y: rect.maxY + 1))
        path.closeSubpath()
        
        return path
    }
}

struct TabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let wScale = width / 320
        let hScale = height / 197
        
        path.move(to: CGPoint(x: 133.678 * wScale, y: 19 * hScale))
        path.addLine(to: CGPoint(x: 185.663 * wScale, y: 19 * hScale))
        
        let control1 = CGPoint(x: 262.404 * wScale, y: 19 * hScale)
        let control2 = CGPoint(x: 235.174 * wScale, y: 142.775 * hScale)
        path.addCurve(
            to: CGPoint(x: 319.341 * wScale, y: 142.775 * hScale),
            control1: control1,
            control2: control2
        )
        
        path.addLine(to: CGPoint(x: 0 * wScale, y: 142.775 * hScale))
        
        let control3 = CGPoint(x: 84.1676 * wScale, y: 142.775 * hScale)
        let control4 = CGPoint(x: 56.937 * wScale, y: 19 * hScale)
        path.addCurve(
            to: CGPoint(x: 133.678 * wScale, y: 19 * hScale),
            control1: control3,
            control2: control4
        )
        
        path.closeSubpath()
        return path
    }
}

struct TabBarCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2.2
        
        path.addEllipse(in: CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        ))
        
        let innerRadius = radius - (2.47551 / 2)
        path.addEllipse(in: CGRect(
            x: center.x - innerRadius,
            y: center.y - innerRadius,
            width: innerRadius * 2,
            height: innerRadius * 2
        ))
        
        return path
    }
}

// MARK: - CustomTabBarButton View
struct CustomTabBarButton: View {
    var body: some View {
        ZStack {
            TabBarShape()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.15, green: 0.17, blue: 0.32),
                        Color(red: 0.24, green: 0.25, blue: 0.45)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .shadow(color: .black, radius: 6)
            TabBarCircle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.96, green: 0.96, blue: 0.98),
                        Color(red: 0.85, green: 0.87, blue: 0.91).opacity(0.7)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(width: 72, height: 72)
                .padding(.vertical, -52)
                .shadow(color: Color.black.opacity(0.8), radius: 12, x: 12, y: 12)
                .shadow(color: Color.white.opacity(0.05), radius: 12, x: -2, y: -2)
                .overlay {
                    TabBarCircle()
                        .stroke(.black, lineWidth: 2)
                }
                .shadow(color: .black, radius: 2)
        }
        .frame(height: 147)
    }
}

#Preview {
    Arc()
        .preferredColorScheme(.dark)
}

