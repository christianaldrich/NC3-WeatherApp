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
    @AppStorage("safeWeatherData", store: UserDefaults(suiteName: packageIdentifier)) private var isClearWeather : Bool = true

    func currentWeather () -> currentWeatherWidgetUtil {
        switch self.isClearWeather {
        case false:
            return .risk
        case true:
            return .safe
        }
    }
    
    func weatherData ()-> String{
        return safeWeatherData
    }
    
}
