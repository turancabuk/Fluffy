//
//  SearchView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 28.10.2024.
//

import SwiftUI

struct SearchView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar ve Search Bar kısmı
            VStack {
                // Back button ve başlık
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.white)
                                .font(.system(size: 23).weight(.medium))
                            Text("Weather")
                                .foregroundStyle(.white)
                                .font(.title)
                        }
                        .frame(height: 44)
                    }
                    Spacer()
                }
                .frame(height: 52)
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search a city or airport", text: $viewModel.searchText)
                        .placeholder(when: viewModel.searchText.isEmpty,
                                     foregroundColor: .gray) {
                            Text("Search a city or airport")
                        }
                        .disabled(viewModel.selectedLocation != nil)
                        .onSubmit {
                            Task {
                                await viewModel.searchLocations()
                            }
                        }
                    if !viewModel.searchText.isEmpty {
                        Button {
                            viewModel.searchText = ""
                            viewModel.clearSelection()  // Seçimi temizle
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(.white)
                        }
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 7)
                .frame(height: 36, alignment: .leading)
                .background(Color.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 10))
                .innerShadow(shape: RoundedRectangle(cornerRadius: 10), color: .black, lineWidth: 1, offsetX: 0, offsetY: 2, blur: 2)
            }
            .padding(.horizontal, 16)
            .padding(.top, 49)
            .padding(.bottom, 16)
            .makeBlurView(radius: 20, opaque: true)
            .background(.color)
            
            // Arama sonuçları listesi
            if !viewModel.searchResults.isEmpty && viewModel.selectedLocation == nil {
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.searchResults) { location in
                            Button {
                                Task {
                                    await viewModel.selectLocation(location)
                                }
                            } label: {
                                LocationCell(location: location)
                            }
                        }
                    }
                    .padding()
                }
            }
            // Seçilen lokasyonun hava durumu
            if viewModel.currentWeather != nil {
                ScrollView(showsIndicators: false) {
                    VStack {
                        ForecastView(
                            currentWeather: viewModel.currentWeather,
                            hourlyWeather: viewModel.hourlyWeather,
                            dailyWeather: viewModel.dailyWeather
                        )
                        .padding(.vertical, 12)
                    }
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 20)
            }
            Spacer()
        }
        .background(LinearGradient(colors: [.black.opacity(0.1), .color1.opacity(0.3), .color1.opacity(0.6)], startPoint: .top, endPoint: .bottom))
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onChange(of: viewModel.searchText) { _ in
            Task {
                await viewModel.searchLocations()
            }
        }
    }
}

#Preview {
    SearchView()
}
