//
//  CoreLocationComponentApp.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import SwiftUI

@main
struct CoreLocationComponentApp: App {
    @ObservedObject var weatherKitManager: WeatherManager = WeatherManager()
    @ObservedObject var locationManager: LocationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherKitManager)
                .environmentObject(locationManager)
        }
    }
}
