//
//  WeatherManager.swift
//  CoreLocationComponent
//
//  Created by Nathanael Juan Gauthama on 09/07/24.
//

import Foundation
import WeatherKit

@MainActor class WeatherManager:ObservableObject {
    @Published var weather: Weather?
    
    func getWeather(latitude: Double, longitude: Double) {
        async {
            do {
                weather = try await Task.detached(priority: .userInitiated) {
                    return try await WeatherService.shared.weather(for: .init(latitude: latitude, longitude: longitude))
                }.value
            } catch {
                fatalError("\(error)")
            }
        }
    }
    
    var symbol: String {
        weather?.currentWeather.symbolName ?? "xmark"
    }
    
    var temp: String {
        let temp = weather?.currentWeather.temperature
        let convertedTemp = temp?.converted(to: .celsius).description
        return convertedTemp ?? "Connecting to Apple Weather Kit"
    }
    
    var hourWeather: [HourWeather] {
            let currentDate = Date()
            let calendar = Calendar.current
            let roundedDate = calendar.date(bySettingHour: calendar.component(.hour, from: currentDate), minute: 0, second: 0, of: currentDate)!

            let hourWeather = weather?.hourlyForecast.forecast.filter { $0.date > roundedDate }
            
            return hourWeather ?? []
    }
}
