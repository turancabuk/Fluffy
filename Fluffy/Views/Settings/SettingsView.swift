import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject private var languageManager = LanguageManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
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
        .environment(\.locale, languageManager.locale)
    }
}
