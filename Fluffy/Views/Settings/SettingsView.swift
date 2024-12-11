import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        Form {
            Section(header: Text("Bildirimler")) {
                Toggle("Günlük Hava Durumu Bildirimi", isOn: Binding(
                    get: { viewModel.notificationsEnabled },
                    set: { _ in viewModel.toggleNotifications() }
                ))
                .tint(.blue)
                
                if viewModel.notificationsEnabled {
                    Text("Her gün saat 08:00'de hava durumu özeti alacaksınız")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("Sıcaklık Birimi")) {
                Picker("Sıcaklık Birimi", selection: Binding(
                    get: {locationManager.usesFahrenheit},
                    set: { newValue in
                        locationManager.usesFahrenheit = newValue
                        Task {
                            await viewModel.getWeather()
                        }
                    }
                )) {
                    Text("Santigrat (°C)").tag(false)
                    Text("Fahrenheit (°F)").tag(true)
                }
                .pickerStyle(.segmented)
                
                Text("Seçilen sıcaklık birimine göre tüm sıcaklık değerleri otomatik olarak dönüştürülecektir.")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
    }
} 
