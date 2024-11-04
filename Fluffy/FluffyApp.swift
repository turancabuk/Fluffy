//
//  FluffyApp.swift
//  Fluffy
//
//  Created by Turan Çabuk on 22.10.2024.
//

import SwiftUI

@main
struct FluffyApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var locationManager   = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    locationManager.requestLocation()
                }
                .environmentObject(locationManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
