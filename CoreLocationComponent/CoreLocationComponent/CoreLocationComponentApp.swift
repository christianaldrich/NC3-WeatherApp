//
//  CoreLocationComponentApp.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import SwiftUI

@main
struct CoreLocationComponentApp: App {
    @StateObject var weatherKitManager: WeatherManager = WeatherManager()
    @StateObject var locationManager: LocationManager = LocationManager()
    @StateObject var viewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel)
                .environmentObject(weatherKitManager)
                .environmentObject(locationManager)
        }
    }
}
