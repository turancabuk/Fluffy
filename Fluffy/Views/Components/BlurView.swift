//
//  BlurView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 23.10.2024.
//

import SwiftUI

class UIBackDropView: UIView {
    override class var layerClass: AnyClass {
        NSClassFromString("CABackdropLayer") ?? CALayer.self
    }
}

struct BackDrop: UIViewRepresentable {
    func makeUIView(context: Context) -> UIBackDropView {
        UIBackDropView()
    }
    
    func updateUIView(_ uiView: UIBackDropView, context: Context) {}
}

struct BlurView: View {
    
    var radius  : CGFloat = 0
    var opaque  : Bool    = true
    
    var body: some View {
        BackDrop()
            .blur(radius: radius, opaque: opaque)
    }
}

#Preview {
    BlurView()
}
