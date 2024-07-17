//
//  CoreLocationComponentApp.swift
//  CoreLocationComponent
//
//  Created by Christian Aldrich Darrien on 10/07/24.
//

import SwiftUI
import WidgetKit

@main
struct CoreLocationComponentApp: App {
    
    init(){
        WidgetCenter.shared.reloadTimelines(ofKind: "WidgetApp")
    }
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
