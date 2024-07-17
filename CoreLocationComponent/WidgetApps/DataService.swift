//
//  DataService.swift
//  WidgetAppExtension
//
//  Created by Reynard Octavius Tan on 13/07/24.
//

import Foundation
import SwiftUI

struct DataService{
    @AppStorage("safeWeatherData", store: UserDefaults(suiteName: packageIdentifier)) private var safeWeatherData = " "
    @AppStorage ("currentWeather", store: UserDefaults(suiteName: packageIdentifier)) private var isWeatherClear = false

    func currentWeather () -> currentWeatherWidgetUtil {
        if isWeatherClear == true {
            return .safe
        }else{
            return .risk
        }
    }
    
    func weatherData ()-> String{
        return safeWeatherData
    }
    
}
