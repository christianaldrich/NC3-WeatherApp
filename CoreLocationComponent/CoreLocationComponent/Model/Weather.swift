//
//  Weather.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import Foundation
import WeatherKit

struct HourWeatherWrapper: Identifiable, Hashable {
    let id = UUID()
    let hourWeather: HourWeather
    
    static func == (lhs: HourWeatherWrapper, rhs: HourWeatherWrapper) -> Bool {
        return lhs.id == rhs.id
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
