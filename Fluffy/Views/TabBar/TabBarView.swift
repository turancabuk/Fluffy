//
//  TabBarView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

struct TabBarView: View {
    
    @StateObject private var viewmodel = ContentViewModel.shared
    var navButtonTapped   : (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Arc()
                .fill(LinearGradient(colors: [.color, .color], startPoint: .topLeading, endPoint: .bottomLeading))
                .frame(height: 88)
                .overlay {
                    ZStack {
                        Arc()
                            .stroke(.color, lineWidth: 2.5)
                            .padding(.top, 40)
                        CustomTabBarButton()
                            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                            .shadow(color: .black, radius: 4, x: 4, y: 6)
                            .overlay {
                                NavigationLink {
                                    SearchView()
                                } label: {
                                    Image(systemName: "map")
                                        .font(.system(size: 30))
                                        .offset(y: -4)
                                        .foregroundStyle(.color)
                                }
                            }
                    }
                }
            HStack {
                Button {
                    navButtonTapped?()
                } label: {
                    Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90.circle")
                        .font(.system(size: 26))
                        .padding(.bottom, 10)
                }
                .shadow(color: .black, radius: 2, x: 4, y: 4)
                Spacer()
                NavigationLink {
                    SettingsView(viewModel: viewmodel)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 24))
                        .padding(.bottom, 8)
                }
                .shadow(color: .black, radius: 2, x: 4, y: 4)
            }
            .font(.title2)
            .padding(.horizontal, 24)
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
