//
//  ContentViewModel.swift
//  Fluffy
//
//  Created by Turan Çabuk on 28.10.2024.
//


import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ContentViewModel
    
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
        }
    }
} 
