//
//  TabBarView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

struct TabBarView: View {
    
    var navButtonTapped   : (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Arc()
                .fill(LinearGradient(colors: [.color, .color], startPoint: .topLeading, endPoint: .bottomLeading))
                .frame(height: 88)
                .overlay {
                    Arc()
                        .stroke(.color1, lineWidth: 0.5)
                }
            HStack {
                Button {
                    navButtonTapped?()
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .frame(width: 44, height: 44)
                }
                Spacer()
                NavigationLink {
                    SearchView()
                } label: {
                    Image(systemName: "list.star")
                        .frame(width: 44, height: 44)
                }
                
            }
            .font(.title2)
            .padding(.horizontal, 24)
            .padding(EdgeInsets(top: 0, leading: 32, bottom: 18, trailing: 32))
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .foregroundStyle(.white)
        .ignoresSafeArea()

    }
}

#Preview {
    TabBarView()
        .preferredColorScheme(.dark)
}
