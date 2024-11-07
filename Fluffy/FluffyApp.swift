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
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    if !hasLaunchedBefore {
                        locationManager.requestLocation()
                        hasLaunchedBefore = true
                        print("FluffyApp.hasLaunchedBefore", hasLaunchedBefore)
                    }
                }
                .environmentObject(locationManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
