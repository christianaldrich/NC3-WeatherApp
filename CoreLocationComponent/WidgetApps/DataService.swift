//
//  DataService.swift
//  WidgetAppExtension
//
//  Created by Reynard Octavius Tan on 13/07/24.
//

import Foundation
import SwiftUI

struct DataService{
    @AppStorage("safeWeatherData", store: UserDefaults(suiteName: "group.com.rey.CoreLocationComponent")) private var safeWeatherData = " "
    @AppStorage ("currentWeather", store: UserDefaults(suiteName: "group.com.rey.CoreLocationComponent")) private var currentWeatherData : currentWeatherWidgetUtil = .risk
//
    func currentWeather () -> currentWeatherWidgetUtil {
        return currentWeatherData
    }
    
    func weatherData ()-> String{
        return safeWeatherData
    }
    
}
