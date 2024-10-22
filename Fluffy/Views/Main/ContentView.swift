//
//  ContentView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI
import BottomSheet

enum BottomSheetPosition: CGFloat, CaseIterable {
    case top    = 0.83  // 702/844
    case middle = 0.385 // 325/844
}

struct ContentView: View {
    
    @State var bottomSheetPosition: BottomSheetPosition = .middle
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("Background")
                    .resizable()
                    .ignoresSafeArea()
                Image("House")
                    .frame(maxHeight: .infinity, alignment: .top)
                    .padding(.top, 257)
                VStack() {
                    HomeInfoView(cityName: "Yozgat", degree: 12, weatherStatus: "cloudy", highestDegree: 16, lowestDegree: 8)
                        .padding(.top, 38)
                    Spacer()
                }
                BottomSheetView(position: $bottomSheetPosition) {

                } content: {
                    ForecastView()
                }
                TabBarView {
                    bottomSheetPosition = .middle
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
