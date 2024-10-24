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
    
    @State var bottomSheetPosition      : BottomSheetPosition = .middle
    @State var bottomSheetTranslation   : CGFloat = BottomSheetPosition.middle.rawValue
    @State var hasDragged               : Bool = false
    var bottomSheetTranslationProrated  : CGFloat {
        (bottomSheetTranslation - BottomSheetPosition.middle.rawValue) / (BottomSheetPosition.top.rawValue - BottomSheetPosition.middle.rawValue)
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                let screenHeight = geometry.size.height + geometry.safeAreaInsets.top + geometry.safeAreaInsets.bottom
                let imageOffset = screenHeight + 36
                ZStack {
                    Image("Background")
                        .resizable()
                        .ignoresSafeArea()
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    // MARK: House Image
                    Image("House")
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, 257)
                        .offset(y: -bottomSheetTranslationProrated * imageOffset)
                    
                    // MARK: Current Weather
                    VStack(spacing: -10 * (1 - bottomSheetTranslationProrated)) {
                        Text("Yozgat")
                            .font(.largeTitle)
                        
                        VStack {
                            Text(attributedString)
                            
                            Text("H:24°   L:18°")
                                .font(.title3.weight(.semibold))
                                .opacity(1 - bottomSheetTranslationProrated)
                        }
                        
                        Spacer()
                    }
                    .padding(.top, 51)
                    .offset(y: -bottomSheetTranslationProrated * 46)
                }

                
                BottomSheetView(position: $bottomSheetPosition) {
                    
                } content: {
                    ForecastView(bottomSheetTranslationProrated: bottomSheetTranslationProrated)
                }
                
                .onBottomSheetDrag { translation in
                    bottomSheetTranslation = translation / screenHeight
                    withAnimation(.easeInOut) {
                        hasDragged = bottomSheetPosition == .middle ? false : true
                    }
                }
                
                TabBarView(navButtonTapped: {
                    
                })
                .offset(y: bottomSheetTranslationProrated * 115)
            }
        }
        .navigationBarHidden(true)
    }
    private var attributedString: AttributedString {
         var string = AttributedString("19°" + (hasDragged ? " | " : "\n ") + "Mostly Clear")
         
         if let temp = string.range(of: "19°") {
             string[temp].font = .system(size: (96 - (bottomSheetTranslationProrated * (96 - 20))), weight: hasDragged ? .semibold : .thin)
             string[temp].foregroundColor = hasDragged ? .secondary : .primary
         }
         
         if let pipe = string.range(of: " | ") {
             string[pipe].font = .title3.weight(.semibold)
             string[pipe].foregroundColor = .secondary.opacity(bottomSheetTranslationProrated)
         }
         
         if let weather = string.range(of: "Mostly Clear") {
             string[weather].font = .title3.weight(.semibold)
             string[weather].foregroundColor = .secondary
         }
         
         return string
     }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}

//                                        string[temp].f fontWeight(hasDragged ? .semibold : .thin))
