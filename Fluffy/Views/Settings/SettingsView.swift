//
//  SettingsView.swift
//  Fluffy
//
//  Created by Turan Çabuk on 02.12.2024.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            // Back button ve başlık
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.primary)
                            .font(.system(size: 23).weight(.medium))
                        Text("Weather")
                            .foregroundStyle(.primary)
                            .font(.title)
                    }
                    .frame(height: 44)
                }
                .padding(EdgeInsets(top: 46, leading: 18, bottom: 0, trailing: 0))
                .background()
                Spacer()
            }
            .frame(height: 102)
            Form {
                Section(header: Text("Notifications")) {
                    Toggle("Daily Weather Summary", isOn: Binding(
                        get: { viewModel.notificationsEnabled },
                        set: { _ in viewModel.toggleNotifications() }
                    ))
                    .tint(.blue)
                    Text("You must turn on notifications to receive a weather summary every day at 08:00.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                    if viewModel.notificationsEnabled {
                        Text("You will receive a weather summary every day at 08:00.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Temperature Unit")) {
                    Picker("Sıcaklık Birimi", selection: Binding(
                        get: {locationManager.usesFahrenheit},
                        set: { newValue in
                            locationManager.usesFahrenheit = newValue
                            Task {
                                await viewModel.getWeather()
                            }
                        }
                    )) {
                        Text("Centigrade (°C)").tag(false)
                        Text("Fahrenheit (°F)").tag(true)
                    }
                    .pickerStyle(.segmented)
                    
                    Text("All temperature values ​​will be converted automatically according to the selected temperature unit.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                
                Section(header: Text("Language")) {
                    Picker("Language", selection: Binding(
                        get: { languageManager.currentLanguage },
                        set: { newValue in
                            withAnimation {
                                languageManager.currentLanguage = newValue
                            }
                        }
                    )) {
                        ForEach(LanguageManager.Language.allCases, id: \.rawValue) { language in
                            Text(language.displayName)
                                .tag(language.rawValue)
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()    }
}

#Preview {
    SettingsView(viewModel: ContentViewModel(locationManager: LocationManager()))
}
