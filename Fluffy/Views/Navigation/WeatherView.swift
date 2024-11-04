//
//  WeatherView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 28.10.2024.
//

//import SwiftUI
//
//struct WeatherView: View {
//    
//    @State private var searchText = ""
//    var searchResults: [Forecast] {
//        if searchText.isEmpty {
//            return Forecast.cities
//        }else{
//            return Forecast.cities.filter {$0.location.contains(searchText)}
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.background2.ignoresSafeArea()
//            ScrollView(showsIndicators: false) {
//                VStack {
//                    ForEach(searchResults) { forecast in
//                        WeatherWidget(forecast: forecast)
//                    }
//                }
//            }
//            .safeAreaInset(edge: .top) {
//                EmptyView()
//                    .frame(height: 110)
//            }
//        }
//        .overlay {
//            NavigationBarView(searchText: $searchText)
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//#Preview {
//    NavigationView {
//        WeatherView()
//            .preferredColorScheme(.dark)
//    }
//}
